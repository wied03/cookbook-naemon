def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  each_role_query = [*@new_resource.roles].map { |r| "role:#{r}" }
  search_query = each_role_query.join ' or '
  monitor_hosts = search(:node, search_query)
  @new_resource.services.each do |svc_name, proc|
    naemon_service svc_name do
      hosts monitor_hosts.map {|h| h['fqdn']}
      instance_eval(&proc)
    end
  end
  monitor_hosts.each do |monitor_host|
    naemon_host monitor_host['fqdn'] do
      address monitor_host['ipaddress']
    end
  end
end
