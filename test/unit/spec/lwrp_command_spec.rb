# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:command' do
  include BswTech::ChefSpec::LwrpTestHelper

  before {
    stub_resources
    temp_lwrp_recipe "package 'blah'"
    RSpec.configure do |config|
      config.cookbook_path = [*config.cookbook_path] << File.join(File.dirname(__FILE__), 'gen_cookbooks')
    end
    @chef_run = ChefSpec::Runner.new do |node|
        node.set['naemon']['server']['packages'] = ['bib']
      end.converge('foo::default')
  }

  after(:each) {
    #cleanup
  }

  it 'sets up the template to be done at the end of the chef run' do
    # arrange

    # act

    # assert
    expect(@chef_run).to install_package('blah')
    pending 'Write this test'
  end

  it 'works properly with 1 command' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly with multiple commands' do
    # arrange

    # act

    # assert
    pending 'Write this test'

  end
end
