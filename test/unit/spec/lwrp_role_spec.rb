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

  def setup_recipe(contents:)
    temp_lwrp_recipe contents: contents + <<-EOF
      # Simulate an immediate apply in order to test the template
      naemon_role 'application' do
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
    resource = @chef_run.find_resource('naemon_role', 'chef role blah')
    expect(resource).to notify('naemon_role[apply]').to(:apply).delayed
  end

  it 'works properly with 1 host, 1 role, 1 service' do
    # arrange
    stub_search(:node, 'role:db').and_return([{:hostname => 'host1.stuff.com'}])
    setup_recipe contents: <<-EOF
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
    expect(@chef_run).to render_file('/etc/naemon/conf.d/hosts.cfg').with_content(<<EOF
define host {
  alias The Box
  host_name host1.stuff.com
  address 172.16.0.1
}
EOF
                         )
    # TODO: Test that we query who's in the role and repeat this process for each node

    pending 'fix this'
  end

  it 'works properly with 2 hosts in 1 role and 2 services' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly with 1 host in 2 different roles with 2 services' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end

  it 'works properly with 2 hosts in 2 different roles with 2 services' do
    # arrange

    # act

    # assert
    pending 'Write this test'
  end
end
