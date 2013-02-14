require 'csv'
require './lib/invoice'

class InvoiceBuilder

  def self.parse_csv(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    @data = contents.collect do |invoice|
      invoice_hash = {}
      invoice_hash[:id] = invoice[:id]
      invoice_hash[:customer_id] = invoice[:customer_id]
      invoice_hash[:merchant_id] = invoice[:merchant_id]
      invoice_hash[:status] = invoice[:status]
      invoice_hash[:status] = invoice[:created_at]
      invoice_hash[:updated_at] = invoice[:updated_at]

      Invoice.new(invoice_hash)
    end
  end

end



