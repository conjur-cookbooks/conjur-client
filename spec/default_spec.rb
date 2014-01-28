require 'spec_helper'

describe 'conjur-client::default' do
  let :chef_run do
    ChefSpec::Runner.new(platform: platform, version: version) do |node|
      node.set['platform_family'] = platform_family if platform_family
    end.converge described_recipe
  end

  context 'ubuntu' do
    let(:platform) { 'ubuntu' }
    let(:version) { '12.04' }
    let(:platform_family) { nil }
    it 'installs conjur apt package' do
      expect(chef_run).to create_remote_file('/var/chef/cache/conjur-4.5.1-0.deb')
      expect(chef_run.remote_file('/var/chef/cache/conjur-4.5.1-0.deb')).to notify('dpkg_package[conjur]').to(:install)
    end
  end
  context 'fedora' do
    let(:platform) { 'centos' }
    let(:platform_family) { 'rhel' }
    let(:version) { '6.2' }
    it 'installs conjur rpm package' do
      expect(chef_run).to create_remote_file('/var/chef/cache/conjur-4.5.1-0.rpm')
      expect(chef_run.remote_file('/var/chef/cache/conjur-4.5.1-0.rpm')).to notify('rpm_package[conjur]').to(:install)
    end
  end
end
