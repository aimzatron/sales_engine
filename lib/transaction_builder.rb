require 'csv'
require './lib/transaction'

class TransactionBuilder

  DEFAULT_FILE = "./data/transactions.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |transaction|
      Transaction.new(transaction)
    end

    Transaction.store(data)
  end

end