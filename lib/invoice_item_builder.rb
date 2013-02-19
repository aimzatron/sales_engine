require 'csv'
require './lib/invoice_item'

class InvoiceItemBuilder

  DEFAULT_FILE = "./data/invoice_items.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |ii|
      ii_hash = {}
      ii_hash[:id] = ii[:id]
      ii_hash[:item_id] = ii[:item_id]
      ii_hash[:invoice_id] = ii[:invoice_id]
      ii_hash[:quantity] = ii[:quantity]
      ii_hash[:unit_price] = ii[:unit_price]
      ii_hash[:created_at] = ii[:created_at]
      ii_hash[:updated_at] = ii[:updated_at]
      ii_hash[:line_revenue] = ii[:quantity].to_i * ii[:unit_price].to_i

      InvoiceItem.new(ii_hash)
    end

    invoice_index = create_invoice_index(data)
    item_index = create_item_index(data)
    revenue_index = create_revenue_index(invoice_index)
    #qty_index = create_qty_index(invoice_index)
    #puts qty_index.inspect


    InvoiceItem.store_invoice_index(invoice_index)
    InvoiceItem.store_item_index(item_index)
    InvoiceItem.store_revenue_index(revenue_index)
    #InvoiceItem.store_qty_index(qty_index)

    InvoiceItem.store(data)
  end

  def self.create_invoice_index(data)
    data.group_by{|invoiceItem| invoiceItem.invoice_id}
  end

  def self.create_item_index(data)
    data.group_by{|invoiceItem| invoiceItem.item_id}
  end

  def self.create_revenue_index(invoice_index)
    #data.group_by{|invoiceItem| invoiceItem.item_id}
    revenue_hash = Hash.new(0)

    invoice_index.each do |id, invoice_items|
      sum = 0
      invoice_items.each do |invoice_item|
        sum = sum + invoice_item.line_revenue
      end
      revenue_hash[id] = sum
    end
    revenue_hash
  end

  # def self.create_qty_index(invoice_index)
  #   qty_hash = Hash.new(0)

  #   invoice_index.each do |id, invoice_items|
  #     sum = 0
  #     invoice_items.each do |invoice_item|
  #       sum = sum + invoice_item.quantity
  #     end
  #     qty_hash[id] = sum
  #   end
  #   qty_hash
  # end


end
