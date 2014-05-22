def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  handle_delayed_apply('naemon_command') { |chef|
    chef.naemon_command 'apply' do
      action :nothing
    end
  }
end

action :apply do
  template '/etc/naemon/conf.d/commands.cfg' do
    cookbook 'naemon'
    variables :resources => node.run_state[:naemon]
  end
end