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

    # # get access to all invoices
    # invoices = Invoice.all

    # # search invoices array for matches where id == merchant_id -> store in an merc_invoices array
    # merc_invoices = invoices.select{|invoice| self.id == invoice.merchant_id}

    # # use the invoices array to cycle through invoice_items and match all instances where id (invoice) == invoice_id (invoice_item) -> store in an invoice_item array
    # invoice_items = InvoiceItem.all

    # merc_invoice_items = merc_invoices.select do |invoice|
    #   invoice_items.select{|invoice_item| invoice.id == invoice_item.invoice_id}
    # end

    # # use invoice_item array and cycle through items data and match all instances where item_id (invoice_item) == id (item)
    # #@merchant_invoice_items = InvoiceItem.all.select{|invoice_item| }

  end

  def invoices
    Invoice.all.select{|invoice| self.id == invoice.merchant_id}
  end

end
