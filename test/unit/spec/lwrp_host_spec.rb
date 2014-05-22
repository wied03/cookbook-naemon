# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::lwrp:host' do
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
    'host'
  end

  def setup_recipe(contents:)
    temp_lwrp_recipe contents: contents + <<-EOF
      # Simulate an immediate apply in order to test the template
      naemon_host 'application' do
        action :apply
      end
    EOF
  end

  it 'sets up the template to be done at the end of the chef run' do
    # assert
    temp_lwrp_recipe contents: <<-EOF
        naemon_host 'host2.stuff.com' do
          address '172.16.0.1'
        end
    EOF

    # act + assert
    resource = @chef_run.find_resource('naemon_host', 'host2.stuff.com')
    expect(resource).to notify('naemon_host[apply]').to(:apply).delayed
  end

  it 'works properly with 1 host with no alias' do
    # arrange
    setup_recipe contents: <<-EOF
        naemon_host 'host2.stuff.com' do
          address '172.16.0.1'
        end
    EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/hosts.cfg').with_content(<<EOF
define host {
  host_name host2.stuff.com
  address 172.16.0.1
}
EOF
                                         )
  end

  it 'works properly with an alias' do
    # arrange
    setup_recipe contents: <<-EOF
            naemon_host 'host2.stuff.com' do
              host_alias 'the key host'
              address '172.16.0.1'
            end
        EOF

    # act + assert
        expect(@chef_run).to render_file('/etc/naemon/conf.d/hosts.cfg').with_content(<<EOF
define host {
  alias the key host
  host_name host2.stuff.com
  address 172.16.0.1
}
EOF
                                             )
  end

  it 'works properly with multiple hosts' do
    # arrange
    setup_recipe contents: <<-EOF
                naemon_host 'host2.stuff.com' do
                  address '172.16.0.1'
                end

                naemon_host 'host3.stuff.com' do
                  address '172.16.0.2'
                end
            EOF

    # act + assert
    expect(@chef_run).to render_file('/etc/naemon/conf.d/hosts.cfg').with_content(<<EOF
define host {
  host_name host2.stuff.com
  address 172.16.0.1
}
define host {
  host_name host3.stuff.com
  address 172.16.0.2
}
EOF
                                                 )
  end
end
