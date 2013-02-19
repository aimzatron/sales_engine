require 'csv'
require './lib/transaction'

class TransactionBuilder

  DEFAULT_FILE = "./data/transactions.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |transaction|
      Transaction.new(transaction)
    end

    invoice_index = create_invoice_index(data)
    results_index = create_results_index(data)

    Transaction.store_invoice_index(invoice_index)
    Transaction.store_results_index(results_index)
    Transaction.store(data)
  end

  def self.create_invoice_index(data)
    data.group_by{|transaction| transaction.invoice_id}
  end

  def self.create_results_index(data)
    data.inject(Hash.new(0)) do |pending, t|
      if t.result == "success"
        pending[t.invoice_id] += 1
      else
        pending[t.invoice_id] += 0
      end
      pending
    end
  end

end