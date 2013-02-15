require './test/test_helper'
require './lib/invoice_item'

class InvoiceItemTest < MiniTest::Unit::TestCase

  describe "creation of instances" do
    def test_it_exists
      invItem = InvoiceItem.new({})
      assert_kind_of InvoiceItem, invItem
    end

    def test_it_is_initialized_from_a_hash_of_data
      data = {:id => '3', :item_id => '523', :invoice_id => '1', :quantity => '8', :unit_price => '34873'}

      invItem = InvoiceItem.new(data)
      assert_equal data[:quantity], invItem.quantity
      assert_equal data[:unit_price], invItem.unit_price
    end
  end

  # describe "Invoice item relationships" do
  #   before do

  #   end

  #   def test_if_x

  #   end
  # end

end