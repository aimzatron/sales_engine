module SalesEngine
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

    def self.find_by_last_name(last_name)
      @data.find {|customer| customer.last_name.downcase == last_name.downcase}
    end

    def self.find_all_by_last_name(last_name)
      @data.select{|customer| customer.first_name.downcase == first_name.downcase}
    end

    def self.find_by_id(id)
      @data.find {|customer| customer.id == id}
    end

    def self.find_all_by_id(id)
      @data.select {|customer| customer.id == id}
    end

    def self.random
      @data.sample
    end

    def invoices
      hash = Invoice.get_index(:customer_id)
      invoices = hash[self.id]
    end

    def transactions
      invoices = self.invoices
      transactions = invoices.collect do |invoice|
        invoice.transactions
      end
    end

    def favorite_merchant
      invoices = self.invoices

      paid_invoices = Invoice.paid_invoices(invoices)
      merchants = paid_invoices.inject(Hash.new(0)) do |hash, paid_invoice|
        hash[paid_invoice.merchant_id] += 1
        hash
      end

      favorite_merchant = merchants.sort_by{|k, v| v}.reverse

      h = Merchant.find_by_id(favorite_merchant[0][0])

    end

  end
end
