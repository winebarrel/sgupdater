require_relative 'helper'
require 'test/unit'
require 'aws-sdk'
require 'yaml'

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
  end

  # テストがpassedになっている場合に、テスト実行後に呼ばれる。テスト後の状態確認とかに使える。
  def cleanup
  end

  # 毎回テスト実行後に呼ばれる
  def teardown
    TestClient::cleanup_security_groups(@@ec2, @@fixture)
  end

  def test_show
  end
end
