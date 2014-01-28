require 'spec_helper'

describe 'conjur-client::ssl_certificate' do
  let :chef_run do
    ChefSpec::Runner.new do |node|
      node.set['conjur']['ssl_certificate'] = 'the-certificate'
    end.converge described_recipe
  end

  it "creates conjur.pem" do
    expect(chef_run).to create_file(File.join(ConjurCLI.openssl_dir, 'certs/conjur.pem')).with(content: 'the-certificate')
    expect(chef_run).to run_execute("c_rehash #{File.join(ConjurCLI.openssl_dir, 'certs')}")
    expect(chef_run).to run_ruby_block("append conjur.pem to /opt/conjur/embedded/ssl/cert.pem")
  end
end
