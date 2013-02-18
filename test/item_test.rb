require './test/test_helper'
require './lib/item'
require './lib/item_builder'
require './lib/invoice_item_builder'
require './lib/merchant_builder'

class ItemTest < MiniTest::Unit::TestCase

  describe "creation of instances" do
    def test_it_exists
      item = Item.new({})
      assert_kind_of Item, item
    end

    def test_it_is_initialized_from_a_hash_of_data
      data = {:id => '1', :name => 'Item Qui Esse'}

      item = Item.new(data)
      assert_equal data[:id], item.id
      assert_equal data[:name], item.name
    end
  end

  describe "test_random" do
    before do
      ItemBuilder.parse_csv
      @data = Item.all
    end

    def test_if_random
      i1 = Item.random
      i2 = Item.random

      20.times do
        break if i1.id != i2.id
        o1 = SalesEngine::Item.random
      end

      refute_equal i1.id, i2.id
    end
  end

  describe "test find methods" do
    before do
      @i1 = {:id => '1', :name => 'black shoes',
             :description => "cool stuff", :unit_price => "75107",
             :merchant_id => "2",
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 14:54:09 UTC"}

      @i2 = {:id => '2', :name => 'blue shoes',
             :description => "more cool stuff", :unit_price => "57107",
             :merchant_id => "2",
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 14:54:09 UTC"}

      @i3 = {:id => '4', :name => 'Black shoes',
             :description => "more cool stuff", :unit_price => "57107",
             :merchant_id => "4",
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 14:54:09 UTC"}

      @i4 = {:id => '2', :name => 'red shoes',
             :description => "even more cool stuff", :unit_price => 75107,
             :merchant_id => "3",
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 14:54:09 UTC"}
    end

    def test_find_by_name_matches_first_result

      i1 = Item.new(@i1)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      item = Item.find_by_name("Black shoes")
      assert_equal "black shoes", item.name
      assert_equal "1", item.id
    end

    def test_find_all_by_name

      i1 = Item.new(@i1)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      items = Item.find_all_by_name("Black shoes")
      assert_equal 2, items.count
    end

    def test_if_find_all_by_name_returns_empty_array_if_name_not_found

      i1 = Item.new(@i1)
      i2 = Item.new(@i3)

      Item.store([i1, i2])

      items = Item.find_all_by_name("blue jeans")
      assert_equal [], items
    end


    def test_find_by_id_matches_first_result

      i1 = Item.new(@i2)
      i2 = Item.new(@i4)


      Item.store([i1, i2])

      item = Item.find_by_id("2")
      assert_equal "blue shoes", item.name
      assert_equal "2", item.id
    end

    def test_find_all_by_id

      i1 = Item.new(@i2)
      i2 = Item.new(@i4)


      Item.store([i1, i2])

      items = Item.find_all_by_id("2")
      assert_equal 2, items.count
    end

    def test_if_find_all_by_id_returns_empty_array_if_id_not_found

      i1 = Item.new(@i1)
      i2 = Item.new(@i4)


      Item.store([i1, i2])

      items = Item.find_all_by_id("10")
      assert_equal [], items
    end

    def test_find_by_desc_matches_first_result

      i1 = Item.new(@i2)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      item = Item.find_by_desc("more cool stuff")
      assert_equal "more cool stuff", item.description
      assert_equal "2", item.id
    end

    def test_find_all_by_desc

      i1 = Item.new(@i2)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      items = Item.find_all_by_desc("more cool stuff")
      assert_equal 2, items.count
    end

    def test_if_find_all_by_desc_returns_empty_array_if_id_not_found

      i1 = Item.new(@i1)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      items = Item.find_all_by_desc("Purple Shoes")
      assert_equal [], items
    end

    def test_find_by_unit_price_matches_first_result

      i1 = Item.new(@i2)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      item = Item.find_by_unit_price("57107")
      assert_equal "57107", item.unit_price
      assert_equal "2", item.id
    end

    def test_find_all_by_unit_price

      i1 = Item.new(@i2)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      items = Item.find_all_by_unit_price("57107")
      assert_equal 2, items.count
    end

    def test_if_find_all_by_unit_price_returns_empty_array_if_id_not_found

      i1 = Item.new(@i2)
      i2 = Item.new(@i3)


      Item.store([i1, i2])

      items = Item.find_all_by_unit_price("77107")
      assert_equal [], items
    end

    def test_find_by_merchant_id_matches_first_result

      i1 = Item.new(@i1)
      i2 = Item.new(@i2)


      Item.store([i1, i2])

      item = Item.find_by_merchant_id("2")
      assert_equal "2", item.merchant_id
      assert_equal "1", item.id
    end

    def test_find_all_by_merchant_id

      i1 = Item.new(@i1)
      i2 = Item.new(@i2)


      Item.store([i1, i2])

      items = Item.find_all_by_merchant_id("2")
      assert_equal 2, items.count
    end

    def test_if_find_all_by_merchant_id_returns_empty_array_if_id_not_found

      i1 = Item.new(@i1)
      i2 = Item.new(@i2)


      Item.store([i1, i2])

      items = Item.find_all_by_merchant_id("9")
      assert_equal [], items
    end
  end

  describe "Item relationships" do

    before "" do
      ItemBuilder.parse_csv
      InvoiceItemBuilder.parse_csv
      MerchantBuilder.parse_csv

      @item = Item.find_by_name("Item Saepe Ipsum")
    end

    def test_if_invoice_items_are_returned_for_an_item
      invoice_items = @item.invoice_items
      assert_equal 8  , invoice_items.size
    end

    def test_if_a_merchant_is_returned_for_an_item
      merchant = @item.merchant
      assert_equal "Kilback Inc", merchant.name
    end

  end

end