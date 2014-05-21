def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  search_query = "role:#{@new_resource.roles}"
  monitor_hosts = search(:node, search_query)
  monitor_hosts.each do |monitor_host|
    @new_resource.services.each do |svc_name, proc|
      naemon_service svc_name do
        host monitor_host['hostname']
        instance_eval(&proc)
      end
    end
  end
end

action :apply do

end