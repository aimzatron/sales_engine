require './test/test_helper'

module SalesEngine
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
        assert_equal '4354495077693036', transaction.credit_card_number
        assert_equal data[:result], transaction.result
      end
    end

    describe "find by methods" do
      before do
        TransactionBuilder.parse_csv
      end

      def test_if_trans_can_be_found_by_result
        trans = Transaction.find_all_by_result("success")
        assert_operator 4600, :<=, trans.count
      end

      def test_if_trans_can_be_found_by_result
        t = Transaction.find_by_credit_card_number("4634664005836219")
        assert_equal 5536, t.id
      end

    end

    describe "test_random" do
      before do
        TransactionBuilder.parse_csv
      end

      def test_if_random
        t1 = Transaction.random
        t2 = Transaction.random

        20.times do
          break if t1.id != t2.id
          t1 = Transaction.random
        end

        refute_equal t1.id, t2.id
      end
    end

    describe "transaction relationships " do
      before do
        InvoiceBuilder.parse_csv
        t = {:id => 1138, :invoice_id => 982,
              :credit_card_number => '4031429122375205',
              :credit_card_expiration_date => '',
              :result => "success",
              :created_at => "2012-03-27 14:54:56 UTC",
              :updated_at => "2012-03-27 14:54:56 UTC"}

        @t = Transaction.new(t)
        CustomerBuilder.parse_csv
      end

      def test_if_invoice_is_returned_for_transaction

        invoice = @t.invoice
        invoice_customer = Customer.find_by_id(192)
        transaction_customer = @t.invoice.customer.first_name
        assert_equal invoice_customer.first_name, transaction_customer

      end
    end
  end
end
