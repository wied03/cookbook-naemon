module BswTech
  module DelayedApply
    def trigger_delayed_apply
      cookbook_run_state = node.run_state[:naemon] ||= {}
      lwrp_name = new_resource.resource_name
      for_this_lwrp = cookbook_run_state[lwrp_name] ||= []
      first_one = for_this_lwrp.empty?
      for_this_lwrp << new_resource
      if first_one
        # equivalent to running naemon_command 'apply'
        resource = self.send(lwrp_name.to_s,'apply') do
          action :nothing
        end
        new_resource.notifies :apply, resource, :delayed
      end
    end

    def deferred_resources
      node.run_state[:naemon][new_resource.resource_name]
    end
  end
end
