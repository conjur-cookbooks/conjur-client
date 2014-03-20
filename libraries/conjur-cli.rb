module Conjur
  module Chef
    class Client
      def self.openssl_dir
        result = `openssl version -d`.strip
        raise "openssl version -d failed" unless $? == 0
        result =~ /OPENSSLDIR: "(.*)"/
        $1
      end

      def self.conjur_bootstrap_bucket(node)
        node.conjur['bootstrap-bucket'] || default_bootstrap_bucket
      end
      
      def self.default_bootstrap_bucket
        instance_document = JSON.parse(URI.parse("http://169.254.169.254/latest/dynamic/instance-identity/document").read)
        account_id = instance_document['accountId']
        "conjur-#{account_id}-bootstrap"
      end
    end
  end
end