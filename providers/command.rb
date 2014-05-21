def whyrun_supported?
  true
end

use_inline_resources
include BswTech::DelayedApply

action :create_or_update do
  node.run_state[:naemon] ||= []
  node.run_state[:naemon] << new_resource
  command_apply
end

action :apply do
  template '/etc/naemon/commands.cfg' do
    cookbook 'naemon'
    variables :resources => node.run_state[:naemon]
  end
end