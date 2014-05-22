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

  def lwrps_under_test
    'role'
  end

  it 'works properly with 1 host, 1 role, 1 service' do
    # arrange
    stub_search(:node, 'role:db')
    .and_return([{
                     fqdn: 'host1.stuff.com',
                     ipaddress: '172.16.0.1'
                 }])
    temp_lwrp_recipe contents: <<-EOF
        naemon_role 'chef role blah' do
          roles 'db'
          service 'naemon svc desc' do
            check_command 'the_command2'
          end
        end
    EOF

    # act + assert
    svc_resource = @chef_run.find_resource('naemon_service', 'naemon svc desc')
    expect(svc_resource).to_not be_nil
    expect(svc_resource.check_command).to eq('the_command2')
    expect(svc_resource.host).to eq('host1.stuff.com')
    host_resource = @chef_run.find_resource('naemon_host', 'host1.stuff.com')
    expect(host_resource).to_not be_nil
    host_resource.hostname.should == 'host1.stuff.com'
    host_resource.address.should == '172.16.0.1'
  end

  it 'works properly with 2 hosts in 1 role and 2 services' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly with 2 hosts in 2 different roles with 2 services' do
    # arrange
    stub_search(:node, 'role:db')
    .and_return([{
                     fqdn: 'host1.stuff.com',
                     ipaddress: '172.16.0.1'
                 }])
    stub_search(:node, 'role:web')
    .and_return([{
                     fqdn: 'host2.stuff.com',
                     ipaddress: '172.16.0.2'
                 }])
    temp_lwrp_recipe contents: <<-EOF
            naemon_role 'chef role blah' do
              roles 'db'
              service 'naemon svc desc' do
                check_command 'the_command2'
              end
            end

            naemon_role 'the web role' do
              roles 'web'
              service 'apache' do
                check_command 'apache_command'
              end
            end
    EOF

    # act + assert
    svc_resource_1 = @chef_run.find_resource('naemon_service', 'naemon svc desc')
    expect(svc_resource_1).to_not be_nil
    expect(svc_resource_1.check_command).to eq('the_command2')
    expect(svc_resource_1.host).to eq('host1.stuff.com')
    host_resource_1 = @chef_run.find_resource('naemon_host', 'host1.stuff.com')
    expect(host_resource_1).to_not be_nil
    host_resource_1.hostname.should == 'host1.stuff.com'
    host_resource_1.address.should == '172.16.0.1'
    host_resource_2 = @chef_run.find_resource('naemon_host', 'host2.stuff.com')
    expect(host_resource_2).to_not be_nil
    host_resource_2.hostname.should == 'host2.stuff.com'
    host_resource_2.address.should == '172.16.0.2'
    svc_resource_2 = @chef_run.find_resource('naemon_service', 'apache')
    expect(svc_resource_2).to_not be_nil
    expect(svc_resource_2.check_command).to eq('apache_command')
    expect(svc_resource_2.host).to eq('host2.stuff.com')
  end

  it 'works properly with 1 hosts in 2 different roles with 2 services' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end
end
