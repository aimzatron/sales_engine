require './test/test_helper'
require './lib/item'

class ItemTest < MiniTest::Unit::TestCase

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