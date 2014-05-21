# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:service' do
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
    'service'
  end

  it 'sets up the template to be done at the end of the chef run' do
    # assert
    temp_lwrp_recipe contents: <<-EOF
            naemon_service 'the service' do
              host 'host1'
              check_command 'the_command'
            end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_service', 'the service')
    expect(resource).to notify('naemon_service[apply]').to(:apply).delayed
  end

  it 'works properly with 1 service' do
    # arrange
    temp_lwrp_recipe contents: <<-EOF
        naemon_service 'the service' do
          host 'host2'
          check_command 'the_command2'
        end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_service', 'the service')
    puts "provider is #{resource.inspect}"
    expect(resource.rendered_service).to equal(<<EOF
define command {
  command_name the_command
  command_line /etc/do_stuff
}
EOF
                         )
  end

  it 'works properly when a member of a service group' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly when a member of multiple service groups' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly when variables are supplied' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly with multiple services' do
    # arrange
    temp_lwrp_recipe contents: <<-EOF
            naemon_command 'the_command 1' do
              command_line '/etc/do_stuff'
            end

            naemon_command 'the_command 2' do
              command_line '/etc/do_different_stuff'
            end
    EOF

    # act + assert

    expect(@chef_run).to render_file('/etc/naemon/commands.cfg').with_content(
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
