require 'test_helper'

module SalesEngine
  class SalesEngineTest < MiniTest::Unit::TestCase

    def test_it_exists
      se = SalesEngine.new
      assert_kind_of SalesEngine, se
    end


  end
end