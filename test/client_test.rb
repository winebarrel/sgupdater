require 'test/unit'

class TestClient < Test::Unit::TestCase
  class << self
    # テスト群の実行前に呼ばれる
    def startup
    end

    # テスト群の実行後に呼ばれる
    def shutdown
    end

    # 毎回テスト実行前に呼ばれる
    def setup
    end

    # テストがpassedになっている場合に、テスト実行後に呼ばれる。テスト後の状態確認とかに使える。
    def cleanup
    end

    # 毎回テスト実行後に呼ばれる
    def teardown
    end

    def test_show
    end
  end
end
