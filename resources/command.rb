actions :create_or_update
default_action :create_or_update
attribute :name, :kind_of => String, :name_attribute => true
attribute :command_line, :kind_of => String, :required => true
