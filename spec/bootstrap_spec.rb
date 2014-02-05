require 'spec_helper'

describe 'conjur-client::bootstrap' do
  let(:conjurrc) {
    {
      "account" => 'the-account'
    }
  }
  let :chef_run do
    ChefSpec::Runner.new do |node|
      node.set['conjur']['configuration']['account'] = 'the-account'
      node.set['platform_family'] = platform_family if platform_family
    end.converge described_recipe
  end
  let(:platform_family) { "debian" }
  it 'installs aws-sdk into Chef' do
    chef_run.should install_gem_package('aws-sdk').with(gem_binary: "/opt/conjur/embedded/bin/gem")
  end
  it 'creates /etc/conjur-bootstrap-bucket' do
    chef_run.should create_file('/etc/conjur-bootstrap-bucket').with(
      content: "conjur-the-account-bootstrap",
      mode: '0644'
    )
  end
  it 'creates /etc/conjur-bootstrap.conf' do
    chef_run.should create_template('/etc/init/conjur-bootstrap.conf').with(variables: { start_event: "(local-filesystems and net-device-up IFACE!=lo)"})
  end
end
