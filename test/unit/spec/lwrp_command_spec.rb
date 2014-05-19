# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:command' do
  include BswTech::ChefSpec::LwrpTestHelper

  before {
    stub_resources
    temp_lwrp_recipe contents:"package 'blah'" do
        ChefSpec::Runner.new
    end
  }

  after(:each) {
    cleanup
  }

  it 'sets up the template to be done at the end of the chef run' do
    # arrange

    # act

    # assert
    expect(@chef_run).to install_package('blah2')
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
