require 'yaml'
require 'aws-sdk'

module Sgupdater
  module TestHelper
    def load_test_yaml(filename)
      YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), filename)))
    end

    def aws_credentials(credentials)
      if credentials['profile'] != ''
        cred = Aws::SharedCredentials.new(profile_name: credentials['profile'])
      elsif credentials['access_key_id'] != '' && credentials['secret_access_key'] != ''
        cred = Aws::Credentials.new(
          access_key_id: credentials['access_key_id'],
          secret_access_key: credentials['secret_access_key']
        )
      else
        cred = nil
      end
      cred
    end
  end
end
