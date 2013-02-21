require './test/test_helper'

module SalesEngine
  class InvoiceBuilderTest < MiniTest::Unit::TestCase

    def test_it_exists
      ib = InvoiceBuilder.new
      assert_kind_of InvoiceBuilder, ib
    end

    def test_it_builds_invoices_from_a_csv
      output = InvoiceBuilder.parse_csv("./test/support/invoice_build.csv")
      assert_operator 5, :<=, output.count
    end

    def test_if_invoice_was_created
      output = InvoiceBuilder.parse_csv("./test/support/invoice_build.csv")
      merchant_id = 75
      assert_equal merchant_id, output[1].merchant_id
    end

  end
end
