# Encoding: utf-8

require_relative 'spec_helper'

describe 'naemon::default' do
  before { stub_resources }
  describe 'ubuntu' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'installs Naemon core and Thunk by default' do
      # arrange

      # act

      # assert
      pending 'Write this test'
    end

  end
end
