require 'csv'
require './lib/invoice_item'

class InvoiceItemBuilder

  DEFAULT_FILE = "./data/invoice_items.csv"
  DATA_REPOSITORY = InvoiceItem

  def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |ii|
      #puts ii.class
      ii_hash = ii.to_hash.merge(line_revenue: ii[:quantity].to_i * ii[:unit_price].to_i)

      repo.new(ii_hash)
    end

    invoice_index = index_by(:invoice_id, data, repo)
    item_index    = index_by(:item_id, data, repo)

    revenue_index = create_revenue_index(invoice_index)
    repo.store_index(:revenue, revenue_index)
    repo.store(data)

    #qty_index = create_qty_index(invoice_index)
    #puts qty_index.inspect


    # repo.store_invoice_index(invoice_index)
    # repo.store_item_index(item_index)
    # repo.store_revenue_index(revenue_index)
    #InvoiceItem.store_qty_index(qty_index)

  end

  def self.index_by(attribute, data, repo)
    index = data.group_by { |invoice_item| invoice_item.send(attribute) }
    repo.store_index(attribute, index)
  end

  # def self.create_invoice_index(data)
  #   data.group_by{|invoiceItem| invoiceItem.invoice_id}
  # end

  # def self.create_item_index(data)
  #   data.group_by{|invoiceItem| invoiceItem.item_id}
  # end

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
