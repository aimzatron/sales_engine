require './test/test_helper'
require './lib/invoice_item'
require './lib/invoice_builder'

class InvoiceItemTest < MiniTest::Unit::TestCase

  describe "creation of instances" do
    def test_it_exists
      invItem = InvoiceItem.new({})
      assert_kind_of InvoiceItem, invItem
    end

    def test_it_is_initialized_from_a_hash_of_data
      data = {:id => '3', :item_id => '523',
        :invoice_id => '1', :quantity => '8', :unit_price => '34873'}

      invItem = InvoiceItem.new(data)
      assert_equal data[:quantity], invItem.quantity
      assert_equal data[:unit_price], invItem.unit_price
    end
  end

  describe "invoice item relationships" do

    before do
      i = {:id         => '17',
           :item_id    => '700',
           :invoice_id => '3',
           :quantity   => "10",
           :unit_price => "60",
           :created_at => "2012-03-27 14:54:09 UTC",
           :updated_at => "2012-03-27 15:00:00 UTC"}

      @i = InvoiceItem.new(i)

      InvoiceBuilder.parse_csv("./test/support/invoice_build.csv")
    end

    def test_if_an_invoice_can_be_retrieved
      invoice = @i.invoice
      assert_equal 3, invoice.id
      assert_equal 78, invoice.merchant_id
    end

  end
  

end
