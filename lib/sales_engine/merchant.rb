module SalesEngine
  class Merchant

    attr_reader :id, :name, :created_at, :updated_at

    def initialize(data)
      @id = data[:id]
      @name = data[:name]
      @created_at = data[:created_at]
      @updated_at = data[:updated_at]
    end

    def self.store(merchants)
      @data = merchants
    end

    def self.all
      @data
    end

    def self.find_by_name(name)
      @data.find {|merchant| merchant.name.downcase == name.downcase}
    end

    def self.find_all_by_name(name)
      @data.select{|merchant| merchant.name.downcase == name.downcase}
    end

    def self.find_by_id(id)
      @data.find {|merchant| merchant.id == id}
    end

    def self.find_all_by_id(id)
      @data.select{|merchant| merchant.id == id}
    end

    def self.random
      @data.sample
    end

    def items
      # Item.all.select {|item| self.id == item.merchant_id}
      hash = Item.get_index(:merchant_id)
      items = hash[self.id]
    end

    def invoices
      #Invoice.all.select{|invoice| self.id == invoice.merchant_id}
      hash = Invoice.get_index(:merchant_id)
      invoices = hash[self.id]
    end

    def revenue(date = "")
      invoices = self.invoices

      if date != ""
        invoices_for_date = Invoice.get_invoices_for_date(date)
        invoices = Invoice.filter_for_date(invoices, invoices_for_date)
      end
      paid_invoices = Invoice.paid_invoices(invoices)
      sales = Invoice.total_revenue(paid_invoices)
    end

    def self.revenue(date)
      invoices = Invoice.get_invoices_for_date(date)
      paid_invoice_ids = Transaction.get_paid_invoice_list
      revenue_index = InvoiceItem.get_index(:invoice_revenue)

      sum = 0
      merch_id_rev = invoices.inject(Hash.new(0)) do |memo, inv|
        if paid_invoice_ids.include?(inv.id)
          sum += revenue_index[inv.id]
        end
      end
      sum
    end

    def self.most_revenue(num)
      merchants = self.group_by_revenue
      top_merchants = get_merchants(merchants[0..(num-1)])
    end

    def self.most_items(num)
      merchants = self.group_by_items_sold
      top_merchants = get_merchants(merchants[0..(num-1)])
    end

    def customers_with_pending_invoices
      invoices = self.invoices
      pending_invoices = Invoice.unpaid_invoices(invoices)
      customers = Invoice.get_customers(pending_invoices)
    end

    def favorite_customer
      invoices = self.invoices
      paid_invoices = Invoice.paid_invoices(invoices)
      customers = Invoice.group_by_customer_id(paid_invoices)
      #puts customers.inspect
      Customer.find_by_id(customers[0][0])
    end

    def self.group_by_revenue
      merchants_revenue = @data.inject(Hash.new(0)) do |hash, merchant|
        sales = merchant.revenue
        hash[merchant.id] = sales
        hash
      end
      merchants_revenue = merchants_revenue.sort_by{|k, v| v}.reverse
    end

    def self.get_merchants(merchants)
      merchants.collect{|merchant| self.find_by_id(merchant[0])}
    end

    def self.group_by_items_sold
      merchants_items = @data.inject(Hash.new(0)) do |hash, merchant|
        paid_invoices = Invoice.paid_invoices(merchant.invoices)
        qty = Invoice.total_qty(paid_invoices)
        hash[merchant.id] = qty
        hash
      end
      merchants_items = merchants_items.sort_by{|k,v| v}.reverse
    end

  end
end