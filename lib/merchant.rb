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

  def revenue
    merc_invoices = self.invoices
    clean_invoices = Invoice.extract_pending(merc_invoices)
    calc_revenue(clean_invoices)
  end

  def calc_revenue(clean_invoices)
    clean_invoices.inject(0){|sum, invoice| sum + invoice.revenue}
  end


end
