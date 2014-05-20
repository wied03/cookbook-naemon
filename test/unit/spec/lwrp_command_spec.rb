# Encoding: utf-8

require_relative 'spec_helper'

RSpec::Matchers.define :match_irrespective_of_whitespace do |expected|
  match do |actual|
     actual.should == expected
  end
end

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
    # assert

    pending 'Write this test'
  end

  it 'works properly with 1 command' do
    # arrange
    temp_lwrp_recipe contents: <<-EOF
        naemon_command 'the_command' do
          command_line '/etc/do_stuff'
        end
    EOF

    # act + assert

    expect(@chef_run).to render_file('/etc/naemon/commands.cfg').with_content(
<<EOF
define command {
  command_name the_command
  command_line /etc/do_stuff
}
EOF
)
  end

  it 'works properly with multiple commands' do
    # arrange

    # act

    # assert
    pending 'Write this test'

  end
end
