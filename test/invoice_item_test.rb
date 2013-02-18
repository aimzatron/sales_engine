require './test/test_helper'
require './lib/invoice_item'
require './lib/invoice_builder'
require './lib/invoice_item_builder'
require './lib/item_builder'

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
      assert_equal '8', invItem.quantity
      assert_equal '34873', invItem.unit_price
    end
  end

  describe "invoice item relationships" do

    before do
      ii = {:id        => '16934',
           :item_id    => '1928',
           :invoice_id => '3781',
           :quantity   => '5',
           :unit_price => '5488',
           :created_at => '2012-03-27 14:54:09 UTC',
           :updated_at => '2012-03-27 15:00:00 UTC'}

      InvoiceBuilder.parse_csv
      ItemBuilder.parse_csv

      @ii = InvoiceItem.new(ii)
    end

    def test_if_an_invoice_can_be_retrieved_for_an_invoice_item
      invoice = @ii.invoice
      refute_nil invoice
    end

    def test_if_an_item_ca_be_returned_for_an_invoice_item
      item = @ii.item
      assert_equal "Item Cupiditate Magni", item.name
    end
  end
end
