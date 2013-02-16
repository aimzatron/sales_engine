require './test/test_helper'
require './lib/transaction'
require './lib/invoice_builder'
require './lib/transaction_builder'

class TransactionTest < MiniTest::Unit::TestCase

  describe "creation of instances" do
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

  describe "transaction relationships " do
    before do
      InvoiceBuilder.parse_csv("./test/support/invoice_build.csv")
      @t = {:id => '10', :invoice_id => '11',
            :credit_card_number => '4354495077693036',
            :credit_card_expiration_date => '',
            :result => "success"}
    end

    def test_if_invoice_is_returned_for_transaction
      t = Transaction.new(@t)
      invoice = t.invoice
      assert_equal "177", invoice.merchant_id

    end
  end

  describe "find pending transactions" do
    before do
      TransactionBuilder.parse_csv("./test/support/transaction_build.csv")
    end

    def test_if_unpaid_transactions_can_be_retrieved
      invoice_id = "13"
      transactions = Transaction.pending
      #puts transactions
      assert_equal 0, transactions[invoice_id]
    end
  end


end