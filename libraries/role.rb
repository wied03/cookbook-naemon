require 'chef/resource'

# Made this a real Ruby class to make nesting services within roles easier
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
        @allowed_actions = [:create_or_update, :apply, :nothing]
        @services = {}
        @roles = name
      end

      def roles(arg=nil)
        set_or_return(:roles, arg, :kind_of => [String,Array])
      end

      def service(service_name, &proc)
        @services[service_name] = proc
      end

      def service_ref(service)
        @services[service.description] = service
      end
    end
  end
end