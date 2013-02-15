class Transaction

  attr_reader :id, :invoice_id, :credit_card_number,
              :credit_card_expiration_date, :result, :created_at, :updated_at

  def initialize(data)
    @id = data[:id]
    @invoice_id = data[:invoice_id]
    @credit_card_number = data[:credit_card_number]
    @credit_card_expiration_date = data[:credit_card_expiration_date]
    @result = data[:result]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.store(transactions)
    @data = transactions
  end

  def self.all
    @data
  end

  def invoice
    # Will I need to require invoice.rb when this is live? It currently passes without it
    invoice = Invoice.all.find{|invoice| invoice.id == self.invoice_id}
  end

end