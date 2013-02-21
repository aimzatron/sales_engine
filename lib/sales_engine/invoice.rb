module SalesEngine
  class Invoice

    attr_reader :id, :customer_id, :merchant_id, :status,
                :created_at, :updated_at

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

    def self.create(info)
      invoice = Invoice.new(build_invoice(info))
      Invoice.all.push(invoice)
      add_invoice_item(invoice, info[:items])
      invoice
    end

    def self.build_invoice(info)
      id = @data.size + 1
      data = {}
      data[:id] = id
      data[:customer_id] = info[:customer].id
      data[:merchant_id] = info[:merchant].id
      data[:status] = info[:status]
      data[:created_at] = Date.today
      data[:updated_at] = Date.today
      data
    end

    def self.add_invoice_item(invoice, items)

      invoice_items = InvoiceItem.all
      id = invoice_items.size + 1

      details = group_items(items)

      details.each do |item, qty|
        ii = InvoiceItem.new(build_invoice_item(id, item, qty, invoice.id))
        InvoiceItem.all.push(ii)
        id += 1
      end
    end

    def self.build_invoice_item(id, item, qty, inv_id)
      ii_hash = {}
      ii_hash[:id] = id
      ii_hash[:item_id] = item.id
      ii_hash[:invoice_id] = inv_id
      ii_hash[:quantity] = qty
      ii_hash[:unit_price] = item.unit_price
      ii_hash[:created_at] = Date.today; ii_hash[:updated_at] = Date.today
      ii_hash
    end

    def self.group_items(items)
      items.inject(Hash.new(0)) do |hash, item|
        hash[item] += 1
        hash
      end
    end

    def charge(info)
      tran_id = Transaction.all.size + 1
      data = build_transaction(info, tran_id, self.id)
      t = Transaction.new(data)
      Transaction.all.push(t)
    end

    def build_transaction(info, tran_id, inv_id)
      data = {}
      data[:id] = tran_id
      data[:invoice_id] = inv_id
      data[:credit_card_number] = info[:credit_card_number]
      data[:credit_card_expiration_date] = info[:credit_card_expiration_date]
      data[:result] = info[:result]
      data[:created_at] = Date.today; data[:updated_at] = Date.today
      data
    end

    def self.store_index(attribute, index_data)
      @indexes ||= {}
      @indexes[attribute.to_sym] = index_data
    end

    def self.get_index(attribute)
      @indexes[attribute]
    end

    def self.random
      @data.sample
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
      Transaction.all.select{|transaction| transaction.invoice_id == self.id}
      # hash = Transaction.get_index(:invoice_id)
      # transactions = hash[self.id]
    end

    def invoice_items
      InvoiceItem.all.select{|invoice_item| invoice_item.invoice_id == self.id}
      #puts invoice_items.inspect
      #invoice_items
      #hash = InvoiceItem.get_index(:invoice_id)
      #puts "# here's the id of the invoice #{self.id}"
      #invoice_items = #hash[self.id]
    end

    def items
      all_items = Item.all
      invoice_items = self.invoice_items
      found_items = all_items.select do |item|
        invoice_items.find {|ii| ii.item_id == item.id }
      end

      found_items
      # hash = Item.get_index(:merchant_id)
      # items = hash[self.merchant_id]
      # puts items.inspect
      # items
    end

    def customer
      Customer.all.find {|customer| customer.id == self.customer_id}
    end

    def self.pending

      invoices = @data

      unpaid = unpaid_invoices(invoices)
      # pending_transactions = Transaction.pending
      # #puts transactions.inspect

      # @data.select do |invoice|
      #   pending_transactions.find do |invoice_id, no_of_trans|
      #     invoice_id == invoice.id
      #   end
      # end

     # pending_transactions = Transaction.pending
      #puts transactions.inspect

      # @data.select do |invoice|
      #   pending_transactions.find do |invoice_id, no_of_trans|
      #     invoice_id == invoice.id
      #   end
      # end
    end

    def self.average_revenue(date = "")
      invoices = @data

      if date != ""
        invoices_for_date = Invoice.get_invoices_for_date(date)
        invoices = Invoice.filter_for_date(invoices, invoices_for_date)
      end

      paid = paid_invoices(invoices)

      count = paid.size
      revenue_index = InvoiceItem.get_index(:invoice_revenue)

      revenue = paid.inject(0) do |sales, invoice|
        sales += revenue_index[invoice.id]
      end

      avg_revenue = revenue / count
      avg_revenue.round(2)

    end

    def self.average_items(date = "")
      invoices = @data

      if date != ""
        invoices_for_date = Invoice.get_invoices_for_date(date)
        invoices = Invoice.filter_for_date(invoices, invoices_for_date)
      end

      paid = paid_invoices(invoices)

      count = paid.size
      qty_index = InvoiceItem.get_index(:invoice_qty)

      total_qty = paid.inject(0) do |qty, invoice|
        qty += qty_index[invoice.id]
      end

      avg_qty = BigDecimal.new(total_qty) / count
      avg_qty.round(2)

    end

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
      #puts hash.inspect
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

    def self.filter_for_date(all_invoices, invoices_on_date)
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