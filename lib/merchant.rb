
# require './lib/invoice'
# require './lib/invoice_item'
#require './lib/item'


class Merchant

  attr_reader :id, :name, :created_at, :updated_at

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.store(merchants)
    @data = merchants
  end

  def self.all
    @data
  end

  def self.find_by_name(name)
    @data.find {|merchant| merchant.name.downcase == name.downcase}
  end

  def self.find_all_by_name(name)
    @data.select{|merchant| merchant.name.downcase == name.downcase}
  end

  def self.find_by_id(id)
    @data.find {|merchant| merchant.id.downcase == id.downcase}
  end

  def self.find_all_by_id(id)
    @data.select{|merchant| merchant.id.downcase == id.downcase}
  end

  def self.random
    @data.sample
  end

  def items
    Item.all.select {|item| self.id == item.merchant_id}
  end

  def invoices
    Invoice.all.select{|invoice| self.id == invoice.merchant_id}
  end

  def revenue(date = "")
    invoices = self.invoices
    if date != ""
      invoices = Invoice.extract_date_invoices(date, invoices)
    end
    paid_invoices = filter_pending_invoices(invoices)
    sales = calc_revenue(paid_invoices)
    sales.to_i
  end

  def self.most_revenue(num)
    merchants = self.group_by_revenue
    #puts merchant_hash.inspect
    top_merchants = get_merchants(merchants[0..(num-1)])
  end

  def calc_revenue(paid_invoices)
    paid_invoices.inject(0){|sum, invoice| sum + invoice.revenue}
  end

  def customers_with_pending_invoices
    invoices = self.invoices
    pending_invoices = Invoice.get_pending(invoices)
    #puts pending_invoices.inspect
    customers = Invoice.get_customers(pending_invoices)
  end

  def favorite_customer
    invoices = self.invoices
    paid_invoices = filter_pending_invoices(invoices)
    customers = Invoice.group_by_customer_id(paid_invoices)
    #puts customer_hash.inspect
    Customer.find_by_id(customers[0][0])
  end

  def filter_pending_invoices(invoices)
    Invoice.extract_pending(invoices)
  end

  def self.group_by_revenue
    merchants_revenue = @data.inject(Hash.new(0)) do |hash, merchant|
      sales = merchant.revenue
      hash[merchant.id] = sales
      hash
    end
    merchants_revenue = merchants_revenue.sort_by{|k, v| v}.reverse
  end

  def self.get_merchants(merchants)
    merchants.collect{|merchant| self.find_by_id(merchant[0])}
  end


end
