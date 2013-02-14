require './test/test_helper'
require './lib/merchant'

class MerchantTest < MiniTest::Unit::TestCase


  describe "creation of instances" do
    def test_it_exists
      m = Merchant.new({})
      assert_kind_of Merchant, m
    end

    def test_it_is_initialized_from_a_hash_of_data
      # data = {:id => '5', :name => 'Williamson Group'}

      merchant = Merchant.new({:id => '5', :name => 'Williamson Group'})
      assert_equal '5', merchant.id
      assert_equal 'Williamson Group', merchant.name
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


end