require './test/test_helper'

module SalesEngine
  class MerchantBuilderTest < MiniTest::Unit::TestCase

    def test_it_exists
      cb = CustomerBuilder.new
      assert_kind_of CustomerBuilder, cb
    end

    def test_it_builds_merchants_from_a_csv
      output = CustomerBuilder.parse_csv("./test/support/customer_build.csv")
      assert_operator 5, :<=, output.count
    end

    def test_if_customer_was_created
      output = CustomerBuilder.parse_csv("./test/support/customer_build.csv")
      customer_first_name = "Joey"
      assert_equal customer_first_name, output[0].first_name
    end


  end
end
