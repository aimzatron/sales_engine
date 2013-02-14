require 'csv'
require './lib/invoice'

class InvoiceBuilder

  DEFAULT_FILE = "./data/invoices.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |invoice|
      Invoice.new(invoice)
    end

    Invoice.store(data)
  end

end



