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

  def setup_recipe(contents:)
    temp_lwrp_recipe contents: contents + <<-EOF
    # Simulate an immediate apply in order to test the template
    naemon_command 'application' do
      action :apply
    end
EOF
  end

  it 'sets up the template to be done at the end of the chef run' do
    # assert
    temp_lwrp_recipe contents: <<-EOF
            naemon_command 'the_command' do
              command_line '/etc/do_stuff'
            end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_command','the_command')
    expect(resource).to notify('naemon_command[apply]').to(:apply).delayed
  end

  it 'works properly with 1 command' do
    # arrange
    setup_recipe contents: <<-EOF
        naemon_command 'the_command' do
          command_line '/etc/do_stuff'
        end
    EOF

    # act + assert

    expect(@chef_run).to render_file('/etc/naemon/conf.d/commands.cfg').with_content(
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
    setup_recipe contents: <<-EOF
            naemon_command 'the_command 1' do
              command_line '/etc/do_stuff'
            end

            naemon_command 'the_command 2' do
              command_line '/etc/do_different_stuff'
            end
    EOF

    # act + assert

    expect(@chef_run).to render_file('/etc/naemon/conf.d/commands.cfg').with_content(
                             <<EOF
define command {
  command_name the_command 1
  command_line /etc/do_stuff
}

define command {
  command_name the_command 2
  command_line /etc/do_different_stuff
}
EOF
                         )
  end
end
