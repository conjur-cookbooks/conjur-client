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

openssl_certs_dir = File.join(ConjurCLI.openssl_dir, 'certs')
certificate = node.conjur.ssl_certificate

file File.join(openssl_certs_dir, 'conjur.pem') do
  content certificate
  mode "0644"
end

file "/opt/conjur/embedded/ssl/certs/conjur.pem" do
  content certificate
  mode "0644"
end

execute "c_rehash #{openssl_certs_dir}"
execute "c_rehash /opt/conjur/embedded/ssl/certs"

embedded_cert = "/opt/conjur/embedded/ssl/cert.pem"
ruby_block "append conjur.pem to #{embedded_cert}" do
  block do
    content = File.read(embedded_cert)
    header = <<-HEADER

Conjur
======
    HEADER
    File.write(embedded_cert, [ content, header, certificate ].join("\n"))
  end
  not_if { File.read(embedded_cert).index(certificate) }
end
