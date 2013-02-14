require './test/test_helper'
require './lib/customer'


class CustomerTest < MiniTest::Unit::TestCase


  def test_it_exists
    customer = Customer.new({})
    assert_kind_of Customer, customer
  end

  def test_it_is_initialized_from_a_hash_of_data
    data = {:id => '1', :first_name => 'Joey'}

    customer = Customer.new(data)
    assert_equal data[:id], customer.id
    assert_equal data[:first_name], customer.first_name
  end

end