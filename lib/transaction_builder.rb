require 'csv'
require './lib/transaction'

class TransactionBuilder

  def self.parse_csv(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    @data = contents.collect do |transaction|
      transaction_hash = {}
      transaction_hash[:id] = transaction[:id]
      transaction_hash[:invoice_id] = transaction[:invoice_id]
      transaction_hash[:credit_card_number] = transaction[:credit_card_number]
      transaction_hash[:credit_card_expiration_date] = transaction[:credit_card_expiration_date]
      transaction_hash[:result] = transaction[:result]
      transaction_hash[:created_at] = transaction[:created_at]
      transaction_hash[:updated_at] = transaction[:updated_at]

      Transaction.new(transaction_hash)
    end
  end

end