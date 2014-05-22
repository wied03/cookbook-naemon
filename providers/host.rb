def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  handle_delayed_apply('naemon_host') { |chef|
    chef.naemon_host 'apply' do
      action :nothing
    end
  }
end

action :apply do
  template '/etc/naemon/conf.d/hosts.cfg' do
    cookbook 'naemon'
    variables :resources => node.run_state[:naemon]
  end
end