module BswTech
  module DelayedApply
    def handle_delayed_apply(lwrp)
      key = "#{lwrp}_apply"
      if !node.run_state[key]
        resource = yield self
        node.run_state[key] = true
        new_resource.notifies :apply, resource, :delayed
      end
    end
  end
end