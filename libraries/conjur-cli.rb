module ConjurCLI
  def self.openssl_dir
    result = `openssl version -d`.strip
    raise "openssl version -d failed" unless $? == 0
    result =~ /OPENSSLDIR: "(.*)"/
    $1
  end
end