name              'conjur-client'
maintainer        'Conjur, Inc.'
maintainer_email  'kgilpin@conjur.net'
license           'MIT'
description       'Installs the Conjur command line interface'
version           '0.3.0'

recipe "conjur-client::bootstrap", "Installs an upstart script which will fetch solo.json from an S3 bucket and run chef-solo"
recipe "conjur-client::conjurrc", "Creates /etc/conjur.conf"
recipe "conjur-client::default", "Installs the Conjur client"
recipe "conjur-client::ssl_certificate", "Installs the Conjur virtual appliance SSL certificate"

depends "build-essential"

%w(debian ubuntu centos fedora).each do |platform|
  supports platform
end
