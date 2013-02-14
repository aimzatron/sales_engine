require './test/test_helper'
require './lib/transaction'

class TransactionTest < MiniTest::Unit::TestCase

  def test_it_exists
    t = Transaction.new({})
    assert_kind_of Transaction, t
  end

  def test_it_is_initialized_from_a_hash_of_data
    data = {:id => '3', :invoice_id => '4',
            :credit_card_number => '4354495077693036',
            :credit_card_expiration_date => '',
            :result => "success"}

    transaction = Transaction.new(data)
    assert_equal data[:credit_card_number], transaction.credit_card_number
    assert_equal data[:result], transaction.result
  end


end