class Item

  attr_reader :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at

  def initialize(data)
    @id          = data[:id]
    @name        = data[:name]
    @description  = data[:description]
    @unit_price  = data[:unit_price]
    @merchant_id = data[:merchant_id]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def self.store(items)
    @data = items
  end

  def self.all
    @data
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

  def self.find_by_name(name)
    @data.find{|item| item.name.downcase == name.downcase}
  end

  def self.find_all_by_name(name)
    @data.select{|item| item.name.downcase == name.downcase}
  end

  def self.find_by_id(id)
    @data.find{|item| item.id.downcase == id.downcase}
  end

  def self.find_all_by_id(id)
    @data.select{|item| item.id.downcase == id.downcase}
  end

  def self.find_by_desc(desc)
    @data.find{|item| item.description.downcase == desc.downcase}
  end

  def self.find_all_by_desc(desc)
    @data.select{|item| item.description.downcase == desc.downcase}
  end

  def self.find_by_unit_price(unit_price)
    @data.find{|item| item.unit_price.downcase == unit_price.downcase}
  end

  def self.find_all_by_unit_price(unit_price)
    @data.select{|item| item.unit_price.downcase == unit_price.downcase}
  end

  def self.find_by_merchant_id(merchant_id)
    @data.find{|item| item.merchant_id.downcase == merchant_id.downcase}
  end

  def self.find_all_by_merchant_id(merchant_id)
    @data.select{|item| item.merchant_id.downcase == merchant_id.downcase}
  end

  def invoice_items
    # InvoiceItem.all.select{|inv_item| inv_item.item_id == self.id}
    hash =  InvoiceItem.get_index(:item_id)
    items = hash[self.id]
  end

  def merchant
    Merchant.all.find{|merchant| merchant.id == self.merchant_id}
  end

  def self.most_revenue(num)
    invoice_items = InvoiceItem.all
    paid_invoice_ids = Transaction.get_paid_invoice_list

    item_id_rev = invoice_items.inject(Hash.new(0)) do |memo, inv_item|
      if paid_invoice_ids.include?(inv_item.invoice_id)
        memo[inv_item.item_id] += BigDecimal.new(inv_item.quantity) * BigDecimal.new(inv_item.unit_price)
      end
      #puts inv_item.id
      memo
    end
    sorted = item_id_rev.sort_by { |k,v| v }.reverse
    sorted[0,num.to_i].map { |pair| Item.find_by_id(pair[0]) }
  end

  def self.most_items(num)
    invoice_items = InvoiceItem.all
    paid_invoice_ids = Transaction.get_paid_invoice_list

    item_id_qty = invoice_items.inject(Hash.new(0)) do |memo, inv_item|
      #puts "in inject"
      if paid_invoice_ids.include?(inv_item.invoice_id)
        memo[inv_item.item_id] += BigDecimal.new(inv_item.quantity)
        ## Why didn't .to_i work???? are there nil values?
      end
      memo
    end
    sorted = item_id_qty.sort_by { |k,v| v }.reverse
    #puts sorted.inspect
    sorted[0,num.to_i].map { |pair| Item.find_by_id(pair[0]) }
  end

  def best_day
    merchant_index = Invoice.get_index(:merchant_id)
    invoice_revenue = InvoiceItem.get_index(:invoice_revenue)
    invoices = merchant_index.select do |merchant_id, invoices|
      invoices if merchant_id == self.merchant_id
    end

    paid_invoice_ids = Transaction.get_paid_invoice_list

    days = invoices.values.flatten.inject(Hash.new(0)) do |memo, invoice|
      if paid_invoice_ids.include?(invoice.id)
        revenue = invoice_revenue[invoice.id]
        memo[invoice.created_at] += revenue
      end
      memo
    end

    sorted = days.sort_by{|k,v| v}.reverse
    puts "#{sorted[0][0]} is the best date"
    sorted[0][0]
  end

  def paid_invoice_items
    InvoiceItem.paid_invoice_items(self.invoice_items)

  end

  # def self.group_by_revenue
  #   top_items = @data.inject(Hash.new(0)) do |hash, item|
  #     ii = item.invoice_items
  #     # #puts ii.inspect
  #     paid_ii = InvoiceItem.paid_invoice_items(ii)

  #     revenue = item.calculate_revenue(ii)
  #     puts revenue

  #     hash[item.id] = revenue
  #     hash
  #   end
  #   puts top_items.inspect
  #   top_items = top_items.sort_by{|k,v| v}.reverse
  # end

  # def self.get_items(items)
  #   items.collect{|item| self.find_by_id(item[0])}
  # end

  # def calculate_revenue(ii)
  #   ii.inject(0) do |sum, invoice_item|
  #     sum += invoice_item.line_revenue
  #   end
  # end

end