actions :create_or_update, :apply
default_action :create_or_update
attribute :alias, :kind_of => String, :name_attribute => true
attribute :hostname, :kind_of => String, :required => true
attribute :address, :kind_of => String, :required => true
