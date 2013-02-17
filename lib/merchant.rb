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
    clean_invoices = filter_pending_invoices(invoices)
    calc_revenue(clean_invoices)
  end

  def calc_revenue(clean_invoices)
    clean_invoices.inject(0){|sum, invoice| sum + invoice.revenue}
  end

  def customers_with_pending_invoices
    invoices = self.invoices
    pending_invoices = Invoice.get_pending(invoices)
    customers = Invoice.get_customers(pending_invoices)
  end

  def filter_pending_invoices(invoices)
    Invoice.extract_pending(invoices)
  end


end
