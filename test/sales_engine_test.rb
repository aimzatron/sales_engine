require './test/test_helper'
require './sales_engine'

class SalesEngineTest < MiniTest::Unit::TestCase

  def test_it_exists
    se = SalesEngine.new
    assert_kind_of SalesEngine, se
  end


end