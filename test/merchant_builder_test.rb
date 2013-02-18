require './test/test_helper'
require './lib/merchant_builder'

class MerchantBuilderTest < MiniTest::Unit::TestCase

  def test_it_exists
    mb = MerchantBuilder.new
    assert_kind_of MerchantBuilder, mb
  end

  def test_it_builds_merchants_from_a_csv
    output = MerchantBuilder.parse_csv("./test/support/merchant_build.csv")
    assert_operator 5, :<=, output.count
  end

  def test_if_merchant_was_created
    output = MerchantBuilder.parse_csv("./test/support/merchant_build.csv")
    assert_equal "Schroeder-Jerde", output[0].name
  end


end