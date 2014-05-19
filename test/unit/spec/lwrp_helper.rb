require 'chefspec'

module BswTech
  module ChefSpec
    module LwrpTestHelper
      def generated_cookbook_path
        File.join File.dirname(__FILE__), 'gen_cookbooks'
      end

      def cookbook_path
        File.join generated_cookbook_path, generated_cookbook_name
      end

      def generated_cookbook_name
        'lwrp_gen'
      end

      def temp_lwrp_recipe(contents:)
        create_temp_cookbook(contents)
        RSpec.configure do |config|
          config.cookbook_path = [*config.cookbook_path] << generated_cookbook_path
        end
        raise 'Must supply a block that creates the runner' unless block_given?
        @chef_run = yield
        @chef_run.converge("#{generated_cookbook_name}::default")
      end

      def create_temp_cookbook(contents)
        the_path = cookbook_path
        recipes = File.join the_path, 'recipes'
        FileUtils.mkdir_p recipes
        File.open File.join(recipes, 'default.rb'), 'w' do |f|
          f << contents
        end
        File.open File.join(the_path, 'metadata.rb'), 'w' do |f|
          f << "name '#{generated_cookbook_name}'\n"
          f << "version '0.0.1'\n"
        end
      end

      def cleanup
        FileUtils.rm_rf generated_cookbook_path
      end
    end
  end
end