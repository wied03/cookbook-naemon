# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:role' do
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
    'role'
  end

  def setup_recipe(contents:)
    temp_lwrp_recipe contents: contents + <<-EOF
      # Simulate an immediate apply in order to test the template
      naemon_service 'application' do
        action :apply
      end
    EOF
  end

  it 'sets up the template to be done at the end of the chef run' do
    # assert
    temp_lwrp_recipe contents: <<-EOF
        naemon_role 'chef role blah' do
          roles 'db'
          service 'naemon svc desc' do
            check_command 'the_command2'
          end
        end
    EOF

    # act + assert
    # TODO: Re-enable these 2 tests
    #resource = @chef_run.find_resource('naemon_role', 'chef role blah')
    #expect(resource).to notify('naemon_role[apply]').to(:apply).delayed
    svc_resource = @chef_run.find_resource('naemon_service', 'naemon svc desc')
    expect(svc_resource).to_not be_nil
    expect(svc_resource.check_command).to eq('the_command2')
    expect(svc_resource).to notify('naemon_service[apply]').to(:apply).delayed
    # TODO: Test that we query who's in the role and repeat this process for each node
  end

  it 'works properly with 1 service' do
    # arrange
    setup_recipe contents: <<-EOF
        naemon_service 'the service' do
          host 'host2'
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
    setup_recipe contents: <<-EOF
            naemon_service 'the service' do
              host 'host2'
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
    setup_recipe contents: <<-EOF
                naemon_service 'the service' do
                  host 'host2'
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

  it 'works properly when a member of multiple service groups' do
    # arrange
    setup_recipe contents: <<-EOF
                naemon_service 'the service' do
                  host 'host2'
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
    setup_recipe contents: <<-EOF
            naemon_service 'the service' do
              host 'host2'
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
    setup_recipe contents: <<-EOF
                naemon_service 'the service' do
                  host 'host2'
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
    setup_recipe contents: <<-EOF
                    naemon_service 'the service' do
                      host 'host2'
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
