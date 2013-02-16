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

    # describe "Item relationships" do

    # before "" do
    #   item = {:id => '1999', :name => 'black shoes',
    #          :description => "cool stuff", :unit_price => "75107",
    #          :merchant_id => "7",
    #          :created_at => "2012-03-27 14:54:09 UTC",
    #          :updated_at => "2012-03-27 14:54:09 UTC"}

    #   @item = Item.new(item)

    #   InvoiceItemBuilder.parse_csv("./test/support/invoice_item_build.csv")
    #   MerchantBuilder.parse_csv("./test/support/merchant_build.csv")

    # end

    # def test_if_invoice_items_are_returned_for_an_item
    #   invoice_items = @item.invoice_items
    #   assert_equal 4  , invoice_items.size
    #   assert_equal '19', invoice_items[3].id
    # end

    # def test_if_a_merchant_is_returned_for_an_item
    #   merchant = @item.merchant
    #   assert_equal 'Bernhard-Johns', merchant.name
    #   assert_equal '7', merchant.id
    # end

  end
  

end
