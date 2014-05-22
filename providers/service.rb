def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  handle_delayed_apply('naemon_service') { |chef|
    chef.naemon_service 'apply' do
      action :nothing
    end
  }
end

action :apply do
  template '/etc/naemon/conf.d/services.cfg' do
    cookbook 'naemon'
    variables :resources => node.run_state[:naemon]
  end
end