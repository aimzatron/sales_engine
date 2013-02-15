class Invoice

  attr_reader :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

  def initialize(data)
    @id          = data[:id]
    @customer_id = data[:customer_id]
    @merchant_id = data[:merchant_id]
    @status      = data[:status]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def self.store(invoices)
    @data = invoices
  end

  def self.all
    @data
  end

  def self.find_by_id(id)
    @data.find {|invoice| invoice.id.downcase == id.downcase}
  end

  def self.find_all_by_id(id)
    @data.select {|invoice| invoice.id.downcase == id.downcase}
  end

  def self.find_by_customer_id(customer_id)
    @data.find {|invoice| invoice.customer_id.downcase == customer_id.downcase}
  end

  def self.find_all_by_customer_id(customer_id)
    @data.select {|invoice| invoice.customer_id.downcase == customer_id.downcase}
  end

  def self.find_by_status(status)
    @data.find {|invoice| invoice.status.downcase == status.downcase}
  end

  def self.find_all_by_status(status)
    @data.select {|invoice| invoice.status.downcase == status.downcase}
  end

  def self.find_by_created_at(created_at)
    @data.find {|invoice| invoice.created_at.downcase == created_at.downcase}
  end

  def self.find_all_by_created_at(created_at)
    @data.select {|invoice| invoice.created_at.downcase == created_at.downcase}
  end

  def self.find_by_updated_at(updated_at)
    @data.find {|invoice| invoice.updated_at.downcase == updated_at.downcase}
  end

  def self.find_all_by_updated_at(updated_at)
    @data.select {|invoice| invoice.updated_at.downcase == updated_at.downcase}
  end

  def transactions
    Transaction.all.select{|transaction| transaction.invoice_id == self.id}
  end

end

