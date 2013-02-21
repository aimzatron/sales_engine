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

    def revenue(args = "")
      invoices = self.invoices

      if args.class == Range
        revenue_range(args, invoices)
      else
        if args != ""
          invoices_for_date = Invoice.get_invoices_for_date(args)
          invoices = Invoice.filter_for_date(invoices, invoices_for_date)
        end
        paid_invoices = Invoice.paid_invoices(invoices)
        sales = Invoice.total_revenue(paid_invoices)
      end
    end


    def revenue_range(range, invoices)
      range_invoices = Invoice.get_invoices_for_date_range(range)
      revenue_index = InvoiceItem.get_index(:invoice_revenue)
      selected = invoices & range_invoices

      paid_invoices = Invoice.paid_invoices(selected)

      sales = paid_invoices.inject(0) do |sales, invoice|
        sales += revenue_index[invoice.id]
      end

    end


    def self.revenue(args)
      if args.class == Range
        revenue_range(args)
      else
        invoices = Invoice.get_invoices_for_date(args)
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
    end

    def self.most_revenue(num)
      merchants = self.group_by_revenue
      top_merchants = get_merchants(merchants[0..(num-1)])
    end

    def self.dates_by_revenue(num = "")
      paid_invoice_ids = Transaction.get_paid_invoice_list
      revenue_index = InvoiceItem.get_index(:invoice_revenue)

      dates = Invoice.all.inject(Hash.new(0)) do |memo, invoice|
        if paid_invoice_ids.include?(invoice.id)
          memo[invoice.created_at] += revenue_index[invoice.id]
        end
        memo
      end

      num != "" ? num = num.to_i - 1 : num = -1

      sorted = dates.sort_by{|k, v| v}.reverse
      sorted[0..num].map{ |pair| pair[0] }
    end

    def self.revenue_range(range)
      paid_invoice_ids = Transaction.get_paid_invoice_list

      revenue_index = InvoiceItem.get_index(:invoice_revenue)
      invoices = Invoice.get_invoices_for_date_range(range)

      sum = 0
      invoices.each do |invoice|
        if paid_invoice_ids.include?(invoice.id)
            sum += revenue_index[invoice.id]
        end
      end
      sum
    end


    def self.most_items(num)
      merchants = self.group_by_items_sold
      #puts merchants.inspect
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