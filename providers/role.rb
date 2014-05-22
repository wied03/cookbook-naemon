def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  search_query = "role:#{@new_resource.roles}"
  monitor_hosts = search(:node, search_query)
  monitor_hosts.each do |monitor_host|
    hostname = monitor_host['fqdn']
    naemon_host hostname do
      address monitor_host['ipaddress']
    end
    @new_resource.services.each do |svc_name, proc|
      naemon_service svc_name do
        host hostname
        instance_eval(&proc)
      end
    end
  end
end
