require './test/test_helper'

module SalesEngine
  class InvoiceTest < MiniTest::Unit::TestCase

    describe "creation of instances" do
      def test_it_exists
        invoice = Invoice.new({})
        assert_kind_of Invoice, invoice
      end

      def test_it_is_initialized_from_a_hash_of_data
        data = {:id => 3, :customer_id => 1, :merchant_id => 78, :status => "shipped"}

        invoice = Invoice.new(data)
        assert_equal data[:id], invoice.id
        assert_equal data[:customer_id], invoice.customer_id
        assert_equal data[:merchant_id], invoice.merchant_id
        assert_equal data[:status], invoice.status
      end
    end

    describe "test_find_methods" do
      before do
        @i1 = {:id          => '2',
               :customer_id => "1",
               :merchant_id => "60",
               :status      => "shipped",
               :created_at  => Date.parse("2012-03-27 14:54:09 UTC"),
               :updated_at  => Date.parse("2012-03-27 15:00:00 UTC")}

        @i2 = {:id        => '5',
             :customer_id => "6",
             :merchant_id => "75",
             :status      => "shipped",
             :created_at  => Date.parse("2012-03-27 14:54:09 UTC"),
             :updated_at  => Date.parse("2012-03-27 14:54:09 UTC")}

        @i3 = {:id        => '5',
             :customer_id => "6",
             :merchant_id => "30",
             :status      => "not shipped",
             :created_at  => Date.parse("2012-03-25 14:54:09 UTC"),
             :updated_at  => Date.parse("2012-03-25 14:54:09 UTC")}
        end

        def test_find_by_id_matches_first_result

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoice = Invoice.find_by_id("2")
          assert_equal "2", invoice.id
        end

        def test_find_all_by_id

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)
          i3 = Invoice.new(@i3)

          Invoice.store([i1, i2, i3])

          invoices = Invoice.find_all_by_id("5")
          assert_equal 2, invoices.count
        end

        def test_if_find_all_by_id_returns_empty_array_if_id_not_found

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoices = Invoice.find_all_by_id("2345")
          assert_equal [], invoices
        end

        def test_find_by_customer_id_matches_first_result

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoice = Invoice.find_by_customer_id("1")
          assert_equal "1", invoice.customer_id
          refute_nil invoice
        end

        def test_find_all_by_customer_id

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)
          i3 = Invoice.new(@i3)

          Invoice.store([i1, i2, i3])

          invoices = Invoice.find_all_by_customer_id("6")
          assert_equal 2, invoices.count
        end

        def test_if_find_all_by_customer_id_returns_empty_array_if_id_not_found

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoices = Invoice.find_all_by_id("2345")
          assert_equal [], invoices
        end

        def test_find_by_status_matches_first_result

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoice = Invoice.find_by_status("shipped")
          assert_equal "shipped", invoice.status
          refute_nil invoice
        end

        def test_find_all_by_status

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)
          i3 = Invoice.new(@i3)

          Invoice.store([i1, i2, i3])

          invoices = Invoice.find_all_by_status("shipped")
          assert_equal 2, invoices.count
        end

        def test_if_find_all_by_status_returns_empty_array_if_id_not_found

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoices = Invoice.find_all_by_status("failed")
          assert_equal [], invoices
        end

        def test_find_by_created_at_matches_first_result

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoice = Invoice.find_by_created_at(Date.parse("2012-03-27 14:54:09 UTC"))
          assert_equal Date.parse("2012-03-27 14:54:09 UTC"), invoice.created_at
          refute_nil invoice
        end

        def test_find_all_by_created_at

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)
          i3 = Invoice.new(@i3)

          Invoice.store([i1, i2, i3])

          invoices = Invoice.find_all_by_created_at(Date.parse("2012-03-27 14:54:09 UTC"))
          assert_equal 2, invoices.count
        end

        def test_if_find_all_by_created_at_returns_empty_array_if_id_not_found

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoices = Invoice.find_all_by_id("2012-03-27 16:54:09 UTC")
          assert_equal [], invoices
        end

        def test_find_by_updated_at_matches_first_result

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoice = Invoice.find_by_updated_at(Date.parse("2012-03-27 15:00:00 UTC"))
          assert_equal Date.parse("2012-03-27 15:00:00 UTC"), invoice.updated_at
          refute_nil invoice
        end

        def test_find_all_by_updated_at

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)
          i3 = Invoice.new(@i3)

          Invoice.store([i1, i2, i3])

          invoices = Invoice.find_all_by_updated_at(Date.parse("2012-03-27 15:00:00 UTC"))
          assert_equal 2, invoices.count
        end

        def test_if_find_all_by_updated_at_returns_empty_array_if_id_not_found

          i1 = Invoice.new(@i1)
          i2 = Invoice.new(@i2)

          Invoice.store([i1, i2])

          invoices = Invoice.find_all_by_updated_at(Date.parse("2013-03-27 23:54:09 UTC"))
          assert_equal [], invoices
        end
    end

    describe "Invoice relationships" do
      before do

        InvoiceBuilder.parse_csv
        TransactionBuilder.parse_csv
        InvoiceItemBuilder.parse_csv
        ItemBuilder.parse_csv
        CustomerBuilder.parse_csv

        @i = Invoice.find_by_id(1002)

      end

      def test_if_transactions_of_an_invoice_can_be_retrieved
        transactions = @i.transactions
        assert_equal 1, transactions.count
      end

      def test_if_invoice_items_of_an_invoice_can_be_retrieved
        invoice_items = @i.invoice_items
        assert_equal 3, invoice_items.count
      end

      def test_if_items_of_an_invoice_can_be_retrieved
        item = @i.items.find {|i| i.name == 'Item Accusamus Officia' }
        refute_nil item
      end

      def test_if_customer_is_returned_for_an_invoice
        c = @i.customer
        assert_equal 'Eric', c.first_name
        assert_equal 'Bergnaum', c.last_name
      end
    end

    describe "Invoice Business Intelligence" do

      before do
        InvoiceBuilder.parse_csv
        TransactionBuilder.parse_csv
        InvoiceItemBuilder.parse_csv
        ItemBuilder.parse_csv
        MerchantBuilder.parse_csv
        CustomerBuilder.parse_csv

        @c = Customer.find_by_id(7)
        @m = Merchant.find_by_id(22)
        @i1 = Item.random
        @i2 = Item.random
        @i3 = Item.random

      end

      def test_if_new_invoice_is_successfully_created
        items = [@i1, @i2, @i3]
        invoice = Invoice.create(customer: @c, merchant: @m, items: items)

        assert_equal 7, invoice.customer_id
      end

    end

    # describe "Invoice Extensions" do
    #   before do
    #     TransactionBuilder.parse_csv("./test/support/transaction_build.csv")
    #     InvoiceBuilder.parse_csv("./test/support/invoice_build.csv")
    #   end

    #   def test_if_pending_invoices_can_be_retrieved
    #     pending_invoices = Invoice.pending
    #     #© pending_invoices.inspect
    #     assert_equal 2, pending_invoices.size
    #   end
    # end
  end
end
