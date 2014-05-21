def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  @new_resource.services.each do |svc_name,proc|
    naemon_service svc_name do
      self.instance_eval(&proc)
    end
  end
end

action :apply do

end