module BswTech
  module DelayedApply
    def command_apply
      handle_delayed_apply('naemon_command') { |chef|
        chef.naemon_command 'apply' do
          action :nothing
        end
      }
    end

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