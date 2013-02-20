class Customer

  attr_reader :id, :first_name, :last_name, :created_at, :updated_at

  def initialize(data)
    @id         = data[:id]
    @first_name = data[:first_name]
    @last_name  = data[:last_name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.store(customers)
    @data = customers
  end

  def self.all
    @data
  end

  def self.find_by_first_name(first_name)
    @data.find {|customer| customer.first_name.downcase == first_name.downcase}
  end

  def self.find_all_by_first_name(first_name)
    @data.select{|customer| customer.first_name.downcase == first_name.downcase}
  end

  def self.find_by_id(id)
    @data.find {|customer| customer.id.downcase == id.downcase}
  end

  def self.find_all_by_id(id)
    @data.select {|customer| customer.id.downcase == id.downcase}
  end

  def self.random
    @data.sample
  end

  def invoices
    #Invoice.find_all_by_customer_id(self.id)
    hash = Invoice.get_index(:customer_id)
    invoices = hash[self.id]
  end

  def transactions
    invoices = self.invoices
    transactions = invoices.collect do |invoice|
      t = invoice.transactions
    end
  end

end







