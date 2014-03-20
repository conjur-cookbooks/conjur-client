#
# Copyright (C) 2014 Conjur Inc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe "build-essential"

# Package the AWS SDK so that the bootstrap script can read bootstrap
# credentials from the bucket.
gem_package 'aws-sdk' do
  gem_binary "/opt/conjur/embedded/bin/gem"
end

# Will contain the bootstrap attributes and run-list.
directory "/opt/conjur/etc/chef" do
  recursive true
end

# Run on startup by the upstart job below, it finds out the bucket name,
# and transfers the bootstrap attributes to /opt/conjur/etc/chef.
cookbook_file '/usr/local/bin/conjur-bootstrap-configure' do
  source 'conjur-bootstrap-configure'
  mode '0755'
end

# A file which contains the name of the bootstrap bucket.
file '/etc/conjur-bootstrap-bucket' do
  content Conjur::Chef::Client.conjur_bootstrap_bucket(node)
  mode '0644'
end

start_event = case node['platform_family']
when 'rhel'
  # rhel doesn't seem to support any type of useful startup events like filesystem and network
  "started sshd"
else
  "(local-filesystems and net-device-up IFACE!=lo)"
end

# An upstart job which runs conjur-bootstrap-configure.
template '/etc/init/conjur-bootstrap.conf' do
  source 'conjur-bootstrap.conf.erb'
  variables start_event: start_event
  mode '0644'
end
