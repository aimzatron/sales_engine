require 'csv'
require './lib/invoice_item'

class InvoiceItemBuilder

  DEFAULT_FILE = "./data/invoice_items.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |invoiceItem|
      InvoiceItem.new(invoiceItem)
    end

    InvoiceItem.store(data)
    invoice_index = create_invoice_index(data)
    item_index = create_item_index(data)

    InvoiceItem.store_invoice_index(invoice_index)
    InvoiceItem.store_item_index(item_index)
    #puts index.inspect
  end

  def self.create_invoice_index(data)
    data.group_by{|invoiceItem| invoiceItem.invoice_id}
  end

  def self.create_item_index(data)
    data.group_by{|invoiceItem| invoiceItem.item_id}
  end

end
