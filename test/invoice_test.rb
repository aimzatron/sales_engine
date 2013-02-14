require './test/test_helper'
require './lib/invoice'


class InvoiceTest < MiniTest::Unit::TestCase

  def test_it_exists
    invoice = Invoice.new({})
    assert_kind_of Invoice, invoice
  end

  def test_it_is_initialized_from_a_hash_of_data
    data = {:id => 3, :customer_id => 1, :merchant_id => 78, :status => "shipped"}

    invoice = Invoice.new(data)
    assert_equal data[:id], invoice.id
    assert_equal data[:customer_id], invoice.customer_id
    assert_equal data[:merchant_id], invoice.merchant_id
    assert_equal data[:status], invoice.status
  end


end