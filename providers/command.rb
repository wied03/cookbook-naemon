def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  node.run_state[:naemon] ||= []
  node.run_state[:naemon] << new_resource
  # TODO: Put this in a separate method that can be re-used for other LWRPs
  if !node.run_state[:naemon_command_apply_defined]
    apply_rsrc = naemon_command 'apply' do
      action :nothing
    end
    node.run_state[:naemon_command_apply_defined] = true
    new_resource.notifies :apply, apply_rsrc, :delayed
  end
end

action :apply do
  template '/etc/naemon/commands.cfg' do
    cookbook 'naemon'
    variables :resources => node.run_state[:naemon]
  end
end