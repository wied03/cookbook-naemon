def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  node.run_state[:naemon] ||= []
  node.run_state[:naemon] << new_resource
  handle_delayed_apply('naemon_role') { |chef|
    chef.naemon_role 'apply' do
      action :nothing
    end
  }
end

action :apply do
  already_created_hosts = []
  node.run_state[:naemon].each do |role_resource|
    each_role_query = [*role_resource.roles].map { |r| "role:#{r}" }
    search_query = each_role_query.join ' or '
    monitor_hosts = search(:node, search_query)
    role_resource.services.each do |svc_name, proc|
      naemon_service svc_name do
        hosts monitor_hosts.map { |h| h['fqdn'] }
        instance_eval(&proc)
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
