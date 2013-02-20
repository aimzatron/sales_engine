module SalesEngine
  class TransactionBuilder

    DEFAULT_FILE = "./data/transactions.csv"
    DATA_REPOSITORY = Transaction

    def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = contents.collect do |trans|
        trans_hash = trans.to_hash.merge({id: trans[:id].to_i, invoice_id: trans[:invoice_id].to_i})
        repo.new(trans_hash)
      end

      invoice_index = index_by(:invoice_id, data, repo)

      results_index = create_results_index(data)
      repo.store_index(:results, results_index)

      paid_invoices = create_paid_invoice_list(results_index)
      repo.store_paid_invoice_list(paid_invoices)
      repo.store(data)
    end

    def self.index_by(attribute, data, repo)
      index = data.group_by { |transaction| transaction.send(attribute) }
     # puts index.inspect
      repo.store_index(attribute, index)
    end

    def self.create_paid_invoice_list(index)

      paid = index.select do |invoice_id, result|
        invoice_id if result == 1
      end
      paid.keys

    end

    def self.create_results_index(data)
      data.inject(Hash.new(0)) do |results, t|
        if t.result == "success"
          results[t.invoice_id] += 1
        else
          results[t.invoice_id] += 0
        end
        results
      end
    end

  end
end