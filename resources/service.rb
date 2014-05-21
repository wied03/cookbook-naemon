actions :create_or_update
default_action :create_or_update
attribute :description, :kind_of => String, :name_attribute => true
attribute :host, :kind_of => String, :required => true
attribute :check_command, :kind_of => String, :required => true
attribute :service_groups, :kind_of => Array
attribute :variables, :kind_of => Hash

def rendered_service
  puts 'howdy'
end