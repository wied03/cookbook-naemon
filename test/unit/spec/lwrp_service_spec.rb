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

  def lwrps_under_test
    'service'
  end

  def setup_recipe(contents)
    temp_lwrp_recipe  contents + <<-EOF
      # Simulate an immediate apply in order to test the template
      naemon_service 'application' do
        action :apply
      end
    EOF
  end

  it 'sets up the template to be done at the end of the chef run' do
    # assert
    temp_lwrp_recipe  <<-EOF
        naemon_service 'the service' do
          hosts 'host2'
          check_command 'the_command2'
        end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_service', 'the service')
    expect(resource).to notify('naemon_service[apply]').to(:apply).delayed
  end

  it 'works properly with 1 service' do
    # arrange
    setup_recipe  <<-EOF
        naemon_service 'the service' do
          hosts 'host2'
          check_command 'the_command2'
        end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
}
EOF
                                         )
  end

  it 'works properly when a member of a service group' do
    # arrange
    setup_recipe  <<-EOF
            naemon_service 'the service' do
              hosts 'host2'
              check_command 'the_command2'
              service_groups 'group1'
            end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
  servicegroups group1
}
EOF
                                         )
  end

  it 'works properly when a check interval is supplied' do
    # arrange
    setup_recipe  <<-EOF
                naemon_service 'the service' do
                  hosts 'host2'
                  check_command 'the_command2'
                  check_interval 44
                end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
  check_interval 44
}
EOF
                                         )
  end

  it 'works properly with multiple hosts on a service' do
    # arrange
    setup_recipe  <<-EOF
              naemon_service 'the service' do
                hosts ['host2', 'host3']
                check_command 'the_command2'
              end
        EOF

    # act + assert
        expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2,host3
  check_command the_command2
}
EOF
                                             )
  end

  it 'works properly when a member of multiple service groups' do
    # arrange
    setup_recipe  <<-EOF
                naemon_service 'the service' do
                  hosts 'host2'
                  check_command 'the_command2'
                  service_groups ['group2', 'group1']
                end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
  servicegroups group2,group1
}
EOF
                                         )
  end

  it 'works properly when 1 variable is supplied' do
    # arrange
    setup_recipe  <<-EOF
            naemon_service 'the service' do
              hosts 'host2'
              check_command 'the_command2'
              variables '_DB_TO_CHECK' => 'someDbName'
            end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
  _DB_TO_CHECK someDbName
}
EOF
                                         )
  end

  it 'works properly when multiple variables are supplied' do
    # arrange
    setup_recipe  <<-EOF
                naemon_service 'the service' do
                  hosts 'host2'
                  check_command 'the_command2'
                  variables '_DB_TO_CHECK' => 'someDbName', '_IPTOCHECK' => '172.16.0.1'
                end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
  _DB_TO_CHECK someDbName
  _IPTOCHECK 172.16.0.1
}
EOF
                                         )
  end

  it 'works properly when variables and service groups are supplied' do
    # arrange
    setup_recipe  <<-EOF
                    naemon_service 'the service' do
                      hosts 'host2'
                      check_command 'the_command2'
                      variables '_DB_TO_CHECK' => 'someDbName', '_IPTOCHECK' => '172.16.0.1'
                      service_groups ['group2', 'group1']
                    end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/services.cfg').with_content(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2
  servicegroups group2,group1
  _DB_TO_CHECK someDbName
  _IPTOCHECK 172.16.0.1
}
EOF
                                         )
  end
end
