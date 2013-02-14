require './test/test_helper'
require './lib/transaction_builder'

class TransactionBuilderTest < MiniTest::Unit::TestCase

  def test_it_exists
    tb = TransactionBuilder.new
    assert_kind_of TransactionBuilder, tb
  end

  def test_it_builds_invoices_from_a_csv
    output = TransactionBuilder.parse_csv("./test/support/transaction_build.csv")
    assert_operator 5, :<=, output.count
  end

  def test_if_invoice_was_created
    output = TransactionBuilder.parse_csv("./test/support/transaction_build.csv")
    cc_number = "4515551623735607"
    assert_equal cc_number, output[3].credit_card_number
  end

end