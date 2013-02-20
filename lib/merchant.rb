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
    # Item.all.select {|item| self.id == item.merchant_id}
    hash = Item.get_index(:merchant_id)
    items = hash[self.id]
  end

  def invoices
    #Invoice.all.select{|invoice| self.id == invoice.merchant_id}
    hash = Invoice.get_index(:merchant_id)
    invoices = hash[self.id]
  end

  def revenue(date = "")
    invoices = self.invoices

    if date != ""
      invoices_for_date = Invoice.get_invoices_for_date(date)
      invoices = Invoice.extract_invoices_for_date(invoices, invoices_for_date)
    end
    paid_invoices = Invoice.paid_invoices(invoices)

    #puts paid_invoices.inspect

    sales = Invoice.total_revenue(paid_invoices)
    sales.to_i
  end

  def self.revenue(date)
    #invoices = Invoice.all
    invoices = Invoice.get_invoices_for_date(date)
    paid_invoices = Invoice.paid_invoices(invoices)
    sales = Invoice.total_revenue(paid_invoices).to_i
  end

  def self.most_revenue(num)
    merchants = self.group_by_revenue
    top_merchants = get_merchants(merchants[0..(num-1)])
  end

  def self.most_items(num)
    merchants = self.group_by_items_sold
    #puts merchants.inspect
    top_merchants = get_merchants(merchants[0..(num-1)])
  end

  def customers_with_pending_invoices
    invoices = self.invoices
    # puts invoices.inspect

    pending_invoices = Invoice.unpaid_invoices(invoices)
    # puts pending_invoices.inspect

    customers = Invoice.get_customers(pending_invoices)
    #puts customers.inspect
    #customers
  end

  def favorite_customer
    invoices = self.invoices
    paid_invoices = Invoice.paid_invoices(invoices)
    customers = Invoice.group_by_customer_id(paid_invoices)
    #puts customers.inspect
    Customer.find_by_id(customers[0][0])
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

  def self.group_by_items_sold
    merchants_items = @data.inject(Hash.new(0)) do |hash, merchant|
      paid_invoices = Invoice.paid_invoices(merchant.invoices)
      qty = Invoice.total_qty(paid_invoices)
      hash[merchant.id] = qty
      hash
    end
    merchants_items = merchants_items.sort_by{|k,v| v}.reverse
  end

end
