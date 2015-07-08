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

    def setup_security_groups(ec2, vpc_id, fixture)
      fixture['security_groups'].each do |param|
        group_id = ec2.client.create_security_group(
          {
            group_name: param['group_name'],
            description: param['description'],
            vpc_id: vpc_id,
          }
        ).group_id

        ip_permissions = []
        param['ip_permissions'].each do |ip_perm|
          ip_permissions << {
            ip_protocol: ip_perm['ip_protocol'],
            from_port: ip_perm['from_port'],
            to_port: ip_perm['to_port'],
            ip_ranges: ip_perm['cidr_ip'].map {|ip| {cidr_ip: ip}},
          }
        end
        ec2.client.authorize_security_group_ingress(
          {
            group_id: group_id,
            ip_permissions: ip_permissions
          }
        )
      end
    end

    def cleanup_security_groups(ec2, fixture)
      group_names = fixture['security_groups'].map {|sg| sg['group_name']}
      ec2.client.describe_security_groups(
        filters: [{name: 'group-name', values: group_names}]
      ).security_groups.each do |sg|
        ec2.client.delete_security_group(group_id: sg.group_id)
      end
    end
  end
end
