require './test/test_helper'

module SalesEngine
  class ItemBuilderTest < MiniTest::Unit::TestCase

    def test_it_exists
      ib = ItemBuilder.new
      assert_kind_of ItemBuilder, ib
    end

    def test_it_builds_items_from_a_csv
      output = ItemBuilder.parse_csv("./test/support/item_build.csv")
      assert_operator 5, :<=, output.count
    end

    def test_if_item_was_created
      output = ItemBuilder.parse_csv("./test/support/item_build.csv")
      item_name = "Item Qui Esse"
      assert_equal item_name, output[0].name
    end


  end
end