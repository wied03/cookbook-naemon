# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::default' do
  before { stub_resources }
  describe 'ubuntu' do
    let(:chef_run) { ChefSpec::Runner.new(step_into: ['naemon_command']) do |node|
      node.set['naemon']['server']['packages'] = ['bib']
    end.converge(described_recipe) }

    it 'writes some chefspec code' do
      expect(chef_run).to install_package('bib')
    end
  end
end
