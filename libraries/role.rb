require 'chef/resource'

class Chef
  class Resource
    class NaemonRole < Chef::Resource
      attr_accessor :services

      def initialize(name, run_context=nil)
        super
        @resource_name = :naemon_role
        # Defined LWRP style
        @provider = Chef::Provider::NaemonRole
        @action = :create_or_update
        @allowed_actions = [:create_or_update, :apply]
        @services = {}
      end

      def roles(arg=nil)
        set_or_return(:roles, arg, :kind_of => String)
      end

      def service(service_name, &proc)
        @services[service_name] = proc
      end
    end
  end
end