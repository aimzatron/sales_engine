require './test/test_helper'
require './lib/invoice_item_builder'

class InvoiceItemBuilderTest < MiniTest::Unit::TestCase

  def test_it_exists
    iib = InvoiceItemBuilder.new
    assert_kind_of InvoiceItemBuilder, iib
  end

  def test_it_builds_invoices_from_a_csv
    output = InvoiceItemBuilder.parse_csv("./test/support/invoice_item_build.csv")
    assert_operator 5, :<=, output.count
  end

  def test_if_invoice_was_created
    output = InvoiceItemBuilder.parse_csv("./test/support/invoice_item_build.csv")
    unit_price = "34873"
    assert_equal unit_price, output[2].unit_price
  end

end
