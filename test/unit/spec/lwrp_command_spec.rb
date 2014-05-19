# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:command' do
  include BswTech::ChefSpec::LwrpTestHelper

  before {
    stub_resources
  }

  after(:each) {
    cleanup
  }

  def cookbook_under_test
    'naemon'
  end

  def lwrp_under_test
    'command'
  end

  it 'sets up the template to be done at the end of the chef run' do
    # arrange
    temp_lwrp_recipe contents: 'naemon_command "this is my command"'

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
