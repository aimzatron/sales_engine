require './test/test_helper'

module SalesEngine
  class InvoiceItemTest < MiniTest::Unit::TestCase

    describe "creation of instances" do
      def test_it_exists
        invItem = InvoiceItem.new({})
        assert_kind_of InvoiceItem, invItem
      end

      def test_it_is_initialized_from_a_hash_of_data
        data = {:id => 3, :item_id => 523,
          :invoice_id => 1, :quantity => '8', :unit_price => '34873'}

        invItem = InvoiceItem.new(data)
        assert_equal '8', invItem.quantity
        assert_equal '34873', invItem.unit_price
      end
    end

    describe "test_random" do
      before do
        InvoiceItemBuilder.parse_csv
        @data = InvoiceItem.all
      end

      def test_if_random
        ii1 = InvoiceItem.random
        ii2 = InvoiceItem.random

        10.times do
          break if ii1.id != ii2.id
          c1 = SalesEngine::InvoiceItem.random
        end

        refute_equal ii1.id, ii2.id
      end
    end

    describe "invoice item relationships" do

      before do
        ii = {:id        => 16934,
             :item_id    => 1928,
             :invoice_id => 3781,
             :quantity   => '5',
             :unit_price => '5488',
             :created_at => '2012-03-27 14:54:09 UTC',
             :updated_at => '2012-03-27 15:00:00 UTC'}

        InvoiceItemBuilder.parse_csv
        InvoiceBuilder.parse_csv
        ItemBuilder.parse_csv

        @ii = InvoiceItem.new(ii)
      end

      def test_if_an_invoice_can_be_retrieved_for_an_invoice_item
        invoice = @ii.invoice
        refute_nil invoice
      end

      def test_if_invoice_items_can_be_retrieved_for_an_item_id
        invoice_item = InvoiceItem.find_by_item_id(123)
        assert_equal "Item Doloribus Ducimus", invoice_item.item.name
      end

      def test_if_all_invoices_items_with_given_quantity_can_be_returned
        invoice_items = InvoiceItem.find_all_by_quantity(10)
        assert_equal 2140, invoice_items.count
      end

      def test_if_an_item_can_be_returned_for_an_invoice_item
        item = @ii.item
        assert_equal "Item Cupiditate Magni", item.name
      end
    end
  end
end
