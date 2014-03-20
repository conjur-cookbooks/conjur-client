require 'spec_helper'

describe 'conjur-client::bootstrap' do
  let(:bucket) { nil }
  let(:conjurrc) {
    {
      "account" => 'the-account'
    }
  }
  let :chef_run do
    ChefSpec::Runner.new do |node|
      node.set['conjur']['configuration']['account'] = 'the-account'
      node.set['conjur']['bootstrap-bucket'] = bucket if bucket
      node.set['platform_family'] = platform_family if platform_family
    end.converge described_recipe
  end
  let(:platform_family) { "debian" }
  context "with default bucket" do
    # http://stackoverflow.com/questions/625644/find-out-the-instance-id-from-within-an-ec2-machine/21944204#21944204
    let(:instance_document) {
      {
        "accountId" => "12345678"
      }
    }
    before {
      require 'uri'
      URI.should_receive(:parse).with("http://169.254.169.254/latest/dynamic/instance-identity/document").and_return double("instance-document", read: instance_document.to_json)
    }
    it 'installs aws-sdk into Chef' do
      chef_run.should install_gem_package('aws-sdk').with(gem_binary: "/opt/conjur/embedded/bin/gem")
    end
    it 'creates /etc/conjur-bootstrap-bucket' do
      chef_run.should create_file('/etc/conjur-bootstrap-bucket').with(
        content: "conjur-12345678-bootstrap",
        mode: '0644'
      )
    end
    it 'creates /etc/conjur-bootstrap.conf' do
      chef_run.should create_template('/etc/init/conjur-bootstrap.conf').with(variables: { start_event: "(local-filesystems and net-device-up IFACE!=lo)"})
    end
  end
  context "with specified bucket" do
    let(:bucket) { "ham" }
    it 'creates /etc/conjur-bootstrap-bucket' do
      chef_run.should create_file('/etc/conjur-bootstrap-bucket').with(
        content: "ham",
        mode: '0644'
      )
    end
  end
end
