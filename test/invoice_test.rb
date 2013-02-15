require './test/test_helper'
require './lib/invoice'


class InvoiceTest < MiniTest::Unit::TestCase

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

  describe "test_find_methods" do
    before do
      @i1 = {:id => '2',
             :customer_id => "1",
             :merchant_id => "60",
             :status => "shipped",
             :created_at => "2012-03-27 14:54:09 UTC",
             :updated_at => "2012-03-27 15:00:00 UTC"}

      @i2 = {:id => '5',
           :customer_id => "6",
           :merchant_id => "75",
           :status => "shipped",
           :created_at => "2012-03-27 14:54:09 UTC",
           :updated_at => "2012-03-27 15:00:00 UTC"}

      @i3 = {:id => '5',
           :customer_id => "6",
           :merchant_id => "30",
           :status => "not shipped",
           :created_at => "2012-03-27 11:54:09 UTC",
           :updated_at => "2012-03-27 12:00:00 UTC"}
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

        invoice = Invoice.find_by_created_at("2012-03-27 14:54:09 UTC")
        assert_equal "2012-03-27 14:54:09 UTC", invoice.created_at
        refute_nil invoice
      end

      def test_find_all_by_created_at

        i1 = Invoice.new(@i1)
        i2 = Invoice.new(@i2)
        i3 = Invoice.new(@i3)

        Invoice.store([i1, i2, i3])

        invoices = Invoice.find_all_by_created_at("2012-03-27 14:54:09 UTC")
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

        invoice = Invoice.find_by_updated_at("2012-03-27 15:00:00 UTC")
        assert_equal "2012-03-27 15:00:00 UTC", invoice.updated_at
        refute_nil invoice
      end

      def test_find_all_by_updated_at

        i1 = Invoice.new(@i1)
        i2 = Invoice.new(@i2)
        i3 = Invoice.new(@i3)

        Invoice.store([i1, i2, i3])

        invoices = Invoice.find_all_by_updated_at("2012-03-27 15:00:00 UTC")
        assert_equal 2, invoices.count
      end

      def test_if_find_all_by_updated_at_returns_empty_array_if_id_not_found

        i1 = Invoice.new(@i1)
        i2 = Invoice.new(@i2)

        Invoice.store([i1, i2])

        invoices = Invoice.find_all_by_id("2012-03-27 23:54:09 UTC")
        assert_equal [], invoices
      end




  end

end