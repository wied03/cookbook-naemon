# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:combined' do
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

  def lwrps_under_test
    ['role', 'service', 'host', 'command']
  end

  it 'not confuse apply runs for each resource type' do
    # arrange
    stub_search(:node, 'role:db')
    .and_return([{
                     fqdn: 'host1.stuff.com',
                     ipaddress: '172.16.0.1'
                 }])
    temp_lwrp_recipe contents: <<-EOF
                naemon_command 'the_command2' do
                  command_line '/etc/do_stuff'
                end

                naemon_role 'db' do
                  service 'the service' do
                    check_command 'the_command2'
                  end
                end

                # Have to manually trigger apply with Chefspec

                naemon_role 'apply it' do
                  action :apply
                end

                naemon_host 'hostapply' do
                  action :apply
                end

                naemon_service 'svcapply' do
                  action :apply
                end

                naemon_command 'application' do
                  action :apply
                end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/commands.cfg').with_content(
                                 <<EOF
define command {
  command_name the_command2
  command_line /etc/do_stuff
}
EOF
                             )
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host1.stuff.com
  check_command the_command2
}
EOF
                                         )
    expect(@chef_run).to render_file('/etc/naemon/conf.d/hosts.cfg').with_content(<<EOF
define host {
  host_name host1.stuff.com
  address 172.16.0.1
}
EOF
                                         )
  end
end
