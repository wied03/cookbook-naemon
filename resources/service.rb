actions :create_or_update, :apply
default_action :create_or_update
attribute :description, :kind_of => String, :name_attribute => true
attribute :hosts, :kind_of => [String,Array], :required => true
attribute :check_command, :kind_of => String, :required => true
attribute :service_groups, :kind_of => [String, Array]
attribute :variables, :kind_of => Hash
attribute :check_interval, :kind_of => Integer