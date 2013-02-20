module SalesEngine
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

    # def self.create(info)
    #   id = @data.size + 1
    #   customer = info[:customer] #= data[customer
    #   merchant = info[:merchant] #= customer
    #   status = info[:status] #= customer
    #   items = info[:items]

    #   # INVOICE - :id, :customer_id, :merchant_id, :status, :created_at, :updated_at
    #   data[:id] = id
    #   data[:customer_id] = customer.id
    #   data[:merchant_id] = merchant.id
    #   data[:status] = status
    #   data[:created_at] = Date.today
    #   data[:updated_at] = Date.today


    #   invoice = new(data)
    # end

    # def self.add_invoice_item()
    #   # item_id = 
    # end

    # def charge
    # end

    def self.store_index(attribute, index_data)
      @indexes ||= {}
      @indexes[attribute.to_sym] = index_data
    end

    def self.get_index(attribute)
      @indexes[attribute]
    end

    def self.find_by_id(id)
      @data.find {|invoice| invoice.id == id}
    end

    def self.find_all_by_id(id)
      @data.select {|invoice| invoice.id == id}
    end

    def self.find_by_customer_id(customer_id)
      @data.find {|invoice| invoice.customer_id == customer_id}
    end

    def self.find_all_by_customer_id(customer_id)
      @data.select {|invoice| invoice.customer_id == customer_id}
    end

    def self.find_by_status(status)
      @data.find {|invoice| invoice.status.downcase == status.downcase}
    end

    def self.find_all_by_status(status)
      @data.select {|invoice| invoice.status.downcase == status.downcase}
    end

    def self.find_by_created_at(created_at)
      @data.find {|invoice| invoice.created_at == created_at}
    end

    def self.find_all_by_created_at(created_at)
      @data.select {|invoice| invoice.created_at == created_at}
    end

    def self.find_by_updated_at(updated_at)
      @data.find {|invoice| invoice.updated_at == updated_at}
    end

    def self.find_all_by_updated_at(updated_at)
      @data.select {|invoice| invoice.updated_at == updated_at}
    end

    def transactions
      #Transaction.all.select{|transaction| transaction.invoice_id == self.id}
      hash = Transaction.get_index(:invoice_id)
      transactions = hash[self.id]
    end

    def invoice_items
      #InvoiceItem.all.select{|invoice_item| invoice_item.invoice_id == self.id}
      hash = InvoiceItem.get_index(:invoice_id)
      invoice_items = hash[self.id]
    end

    def items
      hash = Item.get_index(:merchant_id)
      items = hash[self.merchant_id]
    end

    def customer
      Customer.all.find {|customer| customer.id == self.customer_id}
    end

    # def self.pending
    #   # pending_transactions = Transaction.pending
    #   # #puts transactions.inspect

    #   # @data.select do |invoice|
    #   #   pending_transactions.find do |invoice_id, no_of_trans|
    #   #     invoice_id == invoice.id
    #   #   end
    #   # end

    #   pending_transactions = Transaction.pending
    #   #puts transactions.inspect

    #   @data.select do |invoice|
    #     pending_transactions.find do |invoice_id, no_of_trans|
    #       invoice_id == invoice.id
    #     end
    #   end
    # end

    def self.paid_invoices(invoices)
      results_index = Transaction.get_index(:results)
      good_invoices = []

      invoices.each do |invoice|
        results_index.each do |id, result|
          good_invoices.push(invoice) if invoice.id == id && result == 1
        end
      end
      good_invoices

    end

    def self.unpaid_invoices(invoices)
      results_index = Transaction.get_index(:results)

      results = invoices.select do |invoice|
        target = results_index[invoice.id]
        if target.nil? || target == 0
          invoice
        end
      end
    end

    def self.total_revenue(invoices)
      # invoices.inject(0){|sum, invoice| sum + invoice.revenue}
      hash = InvoiceItem.get_index(:invoice_revenue)
      sum = 0
      invoices.each do |invoice|
        hash.each do |id, revenue|
          if invoice.id == id
            sum = sum + revenue
          end
        end
      end
      sum
    end

    def self.total_qty(invoices)
      # #invoices.inject(0){|sum, invoice| sum + invoice.get_quantity}
      hash = InvoiceItem.get_index(:invoice_qty)
      sum = 0
      invoices.each do |invoice|
        hash.each do |id, qty|
          sum += qty if invoice.id == id
        end
      end
      sum
    end

    def self.get_customers(invoices)
      customers = invoices.collect{|invoice| invoice.customer}
      customers = customers.uniq
    end

    def self.get_invoices_for_date(date)
      invoices_on_date = self.find_all_by_created_at(date)
    end

    def self.extract_invoices_for_date(all_invoices, invoices_on_date)
      all_invoices & invoices_on_date
    end

    def self.group_by_customer_id(invoices)
      customer_hash = invoices.inject(Hash.new(0)) do |hash, invoice|
        hash[invoice.customer_id] += 1
        hash
      end
      customer_hash.sort_by{|k, v| v}.reverse
    end


  end
end