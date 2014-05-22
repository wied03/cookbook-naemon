def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  handle_delayed_apply('naemon_role') { |chef|
    chef.naemon_role 'apply' do
      action :nothing
    end
  }
end

action :apply do
  already_created_hosts = []
  already_created_services = []
  node.run_state[:naemon].each do |role_resource|
    each_role_query = [*role_resource.roles].map { |r| "role:#{r}" }
    search_query = each_role_query.join ' or '
    monitor_hosts = search(:node, search_query)
    monitor_hostnames = monitor_hosts.map { |h| h['fqdn'] }
    role_resource.services.each do |svc_name, proc|
      embedded_service_declaration = proc.is_a? Proc
      if embedded_service_declaration
        if !already_created_services.include? svc_name
          naemon_service svc_name do
            hosts monitor_hostnames
            # Allows configuration fo the embedded service resource
            instance_eval(&proc)
          end
          already_created_services << svc_name
        end
      else
        # Service was supplied as an existing resource
        begin
          hosts_already_on_service = proc.hosts
        rescue Chef::Exceptions::ValidationFailed
          # not a problem, they didn't define it yet
          hosts_already_on_service = []
        end
        proc.hosts hosts_already_on_service | monitor_hostnames
      end
    end
    monitor_hosts.each do |monitor_host|
      hostname = monitor_host['fqdn']
      if !already_created_hosts.include? hostname
        naemon_host hostname do
          address monitor_host['ipaddress']
        end
        already_created_hosts << hostname
      end
    end
  end
end
