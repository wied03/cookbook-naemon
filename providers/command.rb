def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  trigger_delayed_apply
end

action :apply do
  template '/etc/naemon/conf.d/commands.cfg' do
    cookbook 'naemon'
    variables :resources => deferred_resources
  end
end