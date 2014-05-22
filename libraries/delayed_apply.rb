module BswTech
  module DelayedApply
    # TODO: Ssee if there is a smarter way to both reuse code and store these resources in the runstate by lwrp.  We probably could also avoid even passing in the LWRP name since we're in a class that's specific to the lwrp
    def handle_delayed_apply(lwrp)
      node.run_state[:naemon] ||= []
      node.run_state[:naemon] << new_resource
      key = "#{lwrp}_apply"
      if !node.run_state[key]
        resource = yield self
        node.run_state[key] = true
        new_resource.notifies :apply, resource, :delayed
      end
    end
  end
end
