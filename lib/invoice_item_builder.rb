require 'csv'
require './lib/invoice_item'

class InvoiceItemBuilder

  def self.parse_csv(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    @data = contents.collect do |invoiceItem|
      invoice_item_hash = {}
      invoice_item_hash[:id] = invoiceItem[:id]
      invoice_item_hash[:item_id] = invoiceItem[:item_id]
      invoice_item_hash[:invoice_id] = invoiceItem[:invoice_id]
      invoice_item_hash[:quantity] = invoiceItem[:quantity]
      invoice_item_hash[:unit_price] = invoiceItem[:unit_price]
      invoice_item_hash[:created_at] = invoiceItem[:created_at]
      invoice_item_hash[:updated_at] = invoiceItem[:updated_at]

      InvoiceItem.new(invoice_item_hash)
    end
  end

end
