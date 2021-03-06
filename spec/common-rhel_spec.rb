# Encoding: utf-8
require_relative 'spec_helper'

describe 'openstack-dns::common' do
  describe 'redhat' do
    let(:runner) { ChefSpec::SoloRunner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) do
      runner.converge(described_recipe)
    end

    include_context 'dns-stubs'

    it 'converges successfully' do
      expect { :chef_run }.to_not raise_error
    end
    it do
      expect(chef_run).to_not include_recipe('openstack-common::logging')
    end
    it do
      expect(chef_run).to upgrade_package('openstack-designate-api')
      expect(chef_run).to upgrade_package('openstack-designate-central')
      expect(chef_run).to upgrade_package('openstack-designate-mdns')
      expect(chef_run).to upgrade_package('openstack-designate-producer')
      expect(chef_run).to upgrade_package('openstack-designate-worker')
      expect(chef_run).to upgrade_package('openstack-designate-sink')
    end
    it do
      expect(chef_run).to upgrade_package('MySQL-python')
    end
    it do
      expect(chef_run).to create_template('/etc/designate/pools.yaml').with(
        source: 'pools.yaml.erb',
        owner: 'designate',
        group: 'designate',
        mode: 00644,
        variables: {
          banner: "\n# This file was autogenerated by Chef\n# Do not edit, changes will be overwritten\n",
          bind_hosts: %w(127.0.0.1),
          masters: %w(127.0.0.1),
          ns_addresses: %w(127.0.0.1),
          ns_hostnames: %w(ns1.example.org.),
          rndc_key: '/etc/designate/rndc.key',
        }
      )
    end
  end
end
