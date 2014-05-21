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
    expect(resource.rendered_service).to eq(<<EOF
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
    temp_lwrp_recipe contents: <<-EOF
            naemon_service 'the service' do
              host 'host2'
              check_command 'the_command2'
              service_groups 'group1'
            end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_service', 'the service')
    expect(resource.rendered_service).to eq(<<EOF
define service {
  service_description the service
  host_name host2
  check_command the_command2

  servicegroups group1


}
EOF
                                         )
  end

  it 'works properly when a member of multiple service groups' do
    # arrange
    temp_lwrp_recipe contents: <<-EOF
                naemon_service 'the service' do
                  host 'host2'
                  check_command 'the_command2'
                  service_groups ['group2', 'group1']
                end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_service', 'the service')
    expect(resource.rendered_service).to eq(<<EOF
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
        temp_lwrp_recipe contents: <<-EOF
            naemon_service 'the service' do
              host 'host2'
              check_command 'the_command2'
              variables '_DB_TO_CHECK' => 'someDbName'
            end
        EOF

        # act + assert
        resource = @chef_run.find_resource('naemon_service', 'the service')
        expect(resource.rendered_service).to eq(<<EOF
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
            temp_lwrp_recipe contents: <<-EOF
                naemon_service 'the service' do
                  host 'host2'
                  check_command 'the_command2'
                  variables '_DB_TO_CHECK' => 'someDbName', '_IPTOCHECK' => '172.16.0.1'
                end
            EOF

            # act + assert
            resource = @chef_run.find_resource('naemon_service', 'the service')
            expect(resource.rendered_service).to eq(<<EOF
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
                temp_lwrp_recipe contents: <<-EOF
                    naemon_service 'the service' do
                      host 'host2'
                      check_command 'the_command2'
                      variables '_DB_TO_CHECK' => 'someDbName', '_IPTOCHECK' => '172.16.0.1'
                      service_groups ['group2', 'group1']
                    end
                EOF

                # act + assert
                resource = @chef_run.find_resource('naemon_service', 'the service')
                expect(resource.rendered_service).to eq(<<EOF
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
