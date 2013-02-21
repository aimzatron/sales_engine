require './test/test_helper'

module SalesEngine
  class SalesEngineTest < MiniTest::Unit::TestCase

    def test_it_can_start_up
      se = SalesEngine.startup
      assert_equal 100, Merchant.all.count
    end

  end
end
