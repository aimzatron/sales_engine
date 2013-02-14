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
  end

end
