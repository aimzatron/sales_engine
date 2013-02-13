require './test/test_helper'
require './lib/merchant'

class MerchantTest < MiniTest::Unit::TestCase

  def test_it_exists
    m = Merchant.new({})
    assert_kind_of Merchant, m
  end

  def test_it_is_initialized_from_a_hash_of_data
    data = {:id => '5', :name => 'Williamson Group'}

    merchant = Merchant.new(data)
    assert_equal data[:id], merchant.id
    assert_equal data[:name], merchant.name
  end


end