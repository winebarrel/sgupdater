require_relative 'helper'
require 'test/unit'
require 'aws-sdk'
require 'yaml'
require 'sgupdater'
require 'sgupdater/client'

class TestClient < Test::Unit::TestCase
  extend Sgupdater::TestHelper
  class << self
    # テスト群の実行前に呼ばれる
    def startup
      @@config = load_test_yaml('aws.yml')
      @@fixture = load_test_yaml('fixture.yml')
      @@cred = aws_credentials(@@config['credentials'])
      @@ec2 = Aws::EC2::Resource.new(region: @@config['region'], credentials: @@cred)
    end

    # テスト群の実行後に呼ばれる
    def shutdown
    end
  end

  # 毎回テスト実行前に呼ばれる
  def setup
    TestClient::setup_security_groups(@@ec2, @@config['vpc_id'], @@fixture)
    cli_options = {from_cidr: '192.0.2.0/24'}
    aws_config = {region: @@config['region'], credentials: @@cred}
    @client = Sgupdater::Client.new(cli_options, aws_config)
  end

  # テストがpassedになっている場合に、テスト実行後に呼ばれる。テスト後の状態確認とかに使える。
  def cleanup
  end

  # 毎回テスト実行後に呼ばれる
  def teardown
    TestClient::cleanup_security_groups(@@ec2, @@fixture)
  end

  def test_show
    @client.get.each do |sg|
      assert_equal(@@config['vpc_id'], sg.vpc_id)

      fx = @@fixture['security_groups'].find {|f| f['group_name'] == sg.group_name}
      assert_equal(fx['group_name'], sg.group_name)
      assert_equal(fx['description'], sg.description)

      sg.ip_permissions.each do |perm|
        fx_perm = fx['ip_permissions'].find {|i|
          i['ip_protocol'] == perm.ip_protocol &&
            i['from_port'] == perm.from_port &&
            i['to_port'] == perm.to_port &&
            i['cidr_ip'] == perm.ip_ranges.map(&:cidr_ip)
        }
        assert_not_nil(fx_perm)
      end
    end
  end
end
