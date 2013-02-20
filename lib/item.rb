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

  # def self.store_merchant_index(index)
  #   @merchant_index = index
  # end

  # def self.get_merchant_index
  #   @merchant_index
  # end

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

end