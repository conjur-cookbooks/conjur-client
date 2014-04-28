require 'spec_helper'

describe 'conjur-client::ssl_certificate' do
  let :chef_run do
    ChefSpec::Runner.new do |node|
      node.set['conjur']['ssl_certificate'] = 'the-certificate'
    end
  end
  let :subject do
    chef_run.converge(described_recipe)
  end

  context "default" do
    it "creates conjur.pem" do
      expect(subject).not_to install_package('openssl-perl')
      expect(subject).to create_file('/opt/conjur/embedded/ssl/certs/conjur.pem').with(content: 'the-certificate')
      expect(subject).to create_file(File.join(Conjur::Chef::Client.openssl_dir, 'certs/conjur.pem')).with(content: 'the-certificate')
      expect(subject).to run_execute("c_rehash #{File.join(Conjur::Chef::Client.openssl_dir, 'certs')}")
      expect(subject).to run_execute("c_rehash /opt/conjur/embedded/ssl/certs")
    end
  end
  context "rhel" do
    it "creates conjur.pem" do
      chef_run.node.automatic['platform_family'] = 'rhel'
      expect(subject).to install_package('openssl-perl')
    end
  end
end
