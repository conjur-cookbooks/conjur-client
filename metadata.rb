name              'conjur-cli'
maintainer        'Conjur, Inc.'
maintainer_email  'kgilpin@conjur.net'
license           'MIT'
description       'Installs the Conjur command line interface'
version           '0.1.0'

%w(debian ubuntu centos fedora).each do |platform|
  supports platform
end
