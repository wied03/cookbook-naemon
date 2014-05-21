actions :create_or_update
default_action :create_or_update
attribute :description, :kind_of => String, :name_attribute => true
attribute :host, :kind_of => String, :required => true
attribute :check_command, :kind_of => String, :required => true
attribute :service_groups, :kind_of => [String, Array]
attribute :variables, :kind_of => Hash

# TODO: Is there a better way to create a resource that is never provided on its own, just more as a building block for other resources?
def rendered_service
  template_path = ::File.join ::File.dirname(__FILE__), '..','templates','default', 'service.cfg.erb'
  ERB.new(::File.new(template_path).read).result(binding)
end