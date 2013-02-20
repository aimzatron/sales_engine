module SalesEngine
  class InvoiceBuilder

    DEFAULT_FILE = "./data/invoices.csv"
    DATA_REPOSITORY = Invoice


    def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = contents.collect do |invoice|

        invoice_hash = invoice.to_hash.merge(created_at: Date.parse(invoice[:created_at]))
        invoice_hash.merge(updated_at: Date.parse(invoice[:updated_at]))
        repo.new(invoice_hash)
      end

      merchant_index = index_by(:merchant_id, data, repo)
      customer_index = index_by(:customer_id, data, repo)
      repo.store(data)
    end

    def self.index_by(attribute, data, repo)
      index = data.group_by { |invoice| invoice.send(attribute) }
     # puts index.inspect
      repo.store_index(attribute, index)
    end
  end
end