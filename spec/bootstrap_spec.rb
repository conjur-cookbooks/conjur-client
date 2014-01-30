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
    end.converge described_recipe
  end
  it 'installs aws-sdk into Chef' do
    chef_run.should install_chef_gem('aws-sdk')
  end
  it 'creates /etc/conjur-bootstrap-bucket' do
    chef_run.should create_file('/etc/conjur-bootstrap-bucket').with(
      content: "conjur-the-account-bootstrap",
      mode: '0644'
    )
  end
  it 'creates /etc/conjur-bootstrap.conf' do
    chef_run.should create_cookbook_file('/etc/init/conjur-bootstrap.conf')
  end
end
