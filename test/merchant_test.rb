require './test/test_helper'

module SalesEngine
  class MerchantTest < MiniTest::Unit::TestCase


    describe "creation of instances" do
      def test_it_exists
        m = Merchant.new({})
        assert_kind_of Merchant, m
      end

      def test_it_is_initialized_from_a_hash_of_data
        merchant = Merchant.new({:id => '5', :name => 'Williamson Group'})
        assert_equal '5', merchant.id
        assert_equal 'Williamson Group', merchant.name
      end
    end

    describe "test_random" do
      before do
        MerchantBuilder.parse_csv
        @data = Merchant.all
      end

      def test_if_random
        m1 = Merchant.random
        m2 = Merchant.random

        20.times do
          break if m1.id != m2.id
          m1 = Merchant.random
        end

        refute_equal m1.id, m2.id
      end
    end

    describe "test_find_methods" do
      before do
        @m1 = {:id => '5', :name => 'Williamson Group',
               :created_at => "2012-03-27 14:54:09 UTC",
               :updated_at => "2012-03-27 14:54:09 UTC"}

        @m2 = {:id => '7', :name => 'WILLIAMSON Group',
              :created_at => "2012-03-27 14:54:09 UTC",
              :updated_at => "2012-03-27 14:54:09 UTC"}

        @m3 = {:id => '7', :name => 'Duplicate Id LLC',
              :created_at => "2012-03-27 14:54:09 UTC",
              :updated_at => "2012-03-27 14:54:09 UTC"}
      end

      def test_find_by_name_matches_first_result

        m1 = Merchant.new(@m1)
        m2 = Merchant.new(@m2)


        Merchant.store([m1, m2])

        merchant = Merchant.find_by_name("Williamson Group")
        assert_equal "Williamson Group", merchant.name
        assert_equal "5", merchant.id
      end

      def test_find_all_by_name

        m1 = Merchant.new(@m1)
        m2 = Merchant.new(@m2)


        Merchant.store([m1, m2])

        merchants = Merchant.find_all_by_name("WilliaMson GRoup")
        assert_equal 2, merchants.count
      end

      def test_if_find_all_by_name_returns_empty_array_if_name_not_found

        m1 = Merchant.new(@m1)
        m2 = Merchant.new(@m2)


        Merchant.store([m1, m2])

        merchants = Merchant.find_all_by_name("Amazon")
        assert_equal [], merchants
      end


      def test_find_by_id_matches_first_result

        m2 = Merchant.new(@m2)
        m3 = Merchant.new(@m3)


        Merchant.store([m2, m3])

        merchant = Merchant.find_by_id("7")
        assert_equal "WILLIAMSON Group", merchant.name
        assert_equal "7", merchant.id
      end

      def test_find_all_by_id

        m2 = Merchant.new(@m2)
        m3 = Merchant.new(@m3)


        Merchant.store([m2, m3])

        merchants = Merchant.find_all_by_id("7")
        assert_equal 2, merchants.count
      end

      def test_if_find_all_by_id_returns_empty_array_if_id_not_found

        m2 = Merchant.new(@m2)
        m3 = Merchant.new(@m3)


        Merchant.store([m2, m3])

        merchants = Merchant.find_all_by_id("10")
        assert_equal [], merchants
      end
    end

    describe "merchant relationships" do
      # Ask why Item class did not need to be required for this test to work!!!!!!
      before do
        MerchantBuilder.parse_csv
        ItemBuilder.parse_csv
        InvoiceBuilder.parse_csv
        CustomerBuilder.parse_csv

        @m = Merchant.find_by_name("Kirlin, Jakubowski and Smitham")

      end

      def test_if_list_of_items_are_returned_for_a_merchant
        items = @m.items
        assert_equal 33, items.count
      end

      def test_if_list_of_invoices_are_returned_for_a_merchant
        invoices = @m.invoices
        assert_equal 43, invoices.count
      end

      # def test_if_invoice_for_customer_named_Block_exists
      #   invoice = @m.invoices.find{|i| i.customer.last_name == 'Block'}
      #   assert_equal "shipped", invoice.status
      # end
    end

    describe "merchant business intelligence" do
      before do

        MerchantBuilder.parse_csv
        InvoiceBuilder.parse_csv
        TransactionBuilder.parse_csv
        InvoiceItemBuilder.parse_csv
        CustomerBuilder.parse_csv

        @m1 = Merchant.find_by_name "Dicki-Bednar"
        @m2 = Merchant.find_by_name("Willms and Sons")
        @m3 = Merchant.find_by_name("Terry-Moore")
        @m4 = Merchant.find_by_name("Parisian Group")
      end

      def test_if_correct_revenue_is_returned_for_a_merchant
        sales = @m1.revenue
        #puts (sales.round(2).to_f)/100
        assert_equal 1148393.74, (sales.round(2).to_f)
      end

      def test_if_top_merchant_by_revenue_is_returned
        merchants = Merchant.most_revenue(3)
        #puts merchants.inspect
        assert_equal "Dicki-Bednar", merchants[0].name
      end

      def test_if_correct_revenue_for_date_is_returned_for_a_merchant
        sales = @m2.revenue(Date.parse("Fri, 09 Mar 2012"))
        assert_equal 8373.29, (sales.round(2).to_f)
      end

      def test_if_total_revenue_for_a_date_is_returned
        sales = Merchant.revenue(Date.parse("Tue, 20 Mar 2012"))
        assert_equal 2549722.91, (sales.round(2).to_f)
      end

      def test_if_customers_with_unpaid_invoices_are_returned
        customers = @m4.customers_with_pending_invoices
        assert_equal 4, customers.size
        #assert_equal "Leanne", customers[1].first_name
      end

      def test_if_favorite_customer_is_found
        customer = @m3.favorite_customer
        assert_equal "Hammes", customer.last_name
        #assert_equal "5", customer.id
      end

      def test_if_top_merchants_by_items_sold_is_returned
        merchants = Merchant.most_items(5)
        assert_equal "Kassulke, O'Hara and Quitzon", merchants[0].name
        assert_equal "Daugherty Group", merchants[4].name
      end

    end

    describe "Merchant Extensions" do
      before do
        MerchantBuilder.parse_csv
        InvoiceBuilder.parse_csv
        TransactionBuilder.parse_csv
        InvoiceItemBuilder.parse_csv
      end

      def test_if_array_of_dates_are_returned_in_desc_order_by_sales
        dates = Merchant.dates_by_revenue
        assert_equal DateTime.parse("2012-03-06"), dates[21]
        assert_equal DateTime.parse("2012-03-09"), dates.first
      end

      def test_if_to_x_days_of_revenue_returned_
        dates = Merchant.dates_by_revenue(5)
        assert_equal 5, dates.size
        assert_equal DateTime.parse("2012-03-08"), dates[1]
        assert_equal DateTime.parse("2012-03-15"), dates.last
      end

      def test_if_revenue_for_invoices_in_date_range_is_returned
        date_1 = Date.parse("2012-03-14")
        date_2 = Date.parse("2012-03-16")
        revenue = Merchant.revenue(date_1..date_2)
        #puts revenue
        assert_equal BigDecimal("8226179.74"), revenue
      end


    end
  end
end
