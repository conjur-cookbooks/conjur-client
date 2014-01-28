require 'spec_helper'

describe 'conjur-client::conjurrc' do
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
  it 'creates conjurrc' do
    expect(chef_run).to create_file('/etc/conjur.conf').with(content: YAML.dump(conjurrc.merge("plugins" => [ 'environment', 'key-pair', 'layer', 'pubkeys' ])))
  end
end
