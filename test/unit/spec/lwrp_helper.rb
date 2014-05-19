module BswTech
  module ChefSpec
    module LwrpTestHelper
      def generated_cookbook_path(scenario_name)
        File.join File.dirname(__FILE__), 'gen_cookbooks', scenario_name
      end

      # TODO: Automatically hook into before/after
      def temp_lwrp_recipe(contents)
        cookbook_name = 'foo'
        the_path = generated_cookbook_path(cookbook_name)
        recipes = File.join the_path, 'recipes'
        FileUtils.mkdir_p recipes
        File.open File.join(recipes, 'default.rb'), 'w' do |f|
          f << contents
        end
        File.open File.join(the_path, 'metadata.rb'), 'w' do |f|
          f << "name '#{cookbook_name}'\n"
          f << "version '0.0.1'\n"
        end
      end

      def cleanup
        FileUtils.rm_rf generated_cookbook_path('foo')
      end
    end
  end
end