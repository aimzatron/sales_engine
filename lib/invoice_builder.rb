
require 'csv'
require './lib/invoice'
require 'Date'

class InvoiceBuilder

  DEFAULT_FILE = "./data/invoices.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |invoice|
      invoice_hash = {}
      invoice_hash[:id] = invoice[:id]
      invoice_hash[:customer_id] = invoice[:customer_id]
      invoice_hash[:merchant_id] = invoice[:merchant_id]
      invoice_hash[:status] = invoice[:status]
      invoice_hash[:created_at] = Date.parse(invoice[:created_at])
      invoice_hash[:updated_at] = Date.parse(invoice[:updated_at])

      Invoice.new(invoice_hash)
    end

    merchant_index = create_merchant_index(data)
    customer_index = create_customer_index(data)

    Invoice.store_merchant_index(merchant_index)
    Invoice.store_customer_index(customer_index)
    Invoice.store(data)
  end

  def self.create_merchant_index(data)
    data.group_by{|invoice| invoice.merchant_id}
  end

  def self.create_customer_index(data)
    data.group_by{|invoice| invoice.customer_id}
  end

end



