def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  template '/etc/naemon/commands.cfg' do
    cookbook 'naemon'
    variables :resource => new_resource
  end
end