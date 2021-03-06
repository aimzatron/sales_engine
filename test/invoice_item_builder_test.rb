require './test/test_helper'

module SalesEngine
  class InvoiceItemBuilderTest < MiniTest::Unit::TestCase

    def test_it_exists
      iib = InvoiceItemBuilder.new
      assert_kind_of InvoiceItemBuilder, iib
    end

    def test_it_builds_invoice_items_from_a_csv
      output = InvoiceItemBuilder.parse_csv("./test/support/invoice_item_build.csv")
      assert_operator 5, :<=, output.count
    end

    def test_if_invoice_item_was_created
      output = InvoiceItemBuilder.parse_csv("./test/support/invoice_item_build.csv")
      assert_equal "34873", output[2].unit_price
    end

  end
end
