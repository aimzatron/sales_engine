require 'bigdecimal'

class InvoiceItem

  attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price, :line_revenue, :created_at, :updated_at

  def initialize(data)
    @id         = data[:id]
    @item_id    = data[:item_id]
    @invoice_id = data[:invoice_id]
    @quantity   = data[:quantity]
    @unit_price = data[:unit_price]
    @line_revenue = data[:line_revenue]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.store(invoice_items)
    @data = invoice_items
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

  #InvoiceItem.get_index(:invoice)

  # def self.store_invoice_index(index)
  #   @invoice_index = index
  # end

  # def self.get_invoice_index
  #   @invoice_index
  # end

  # def self.store_item_index(index)
  #   @item_index = index
  # end

  # def self.get_item_index
  #   @item_index
  # end

  # def self.store_revenue_index(index)
  #   @revenue_index = index
  # end

  # def self.get_revenue_index
  #   @revenue_index
  # end

  # def self.store_qty_index(index)
  #   @qty_index = index
  # end

  # def self.get_qty_index
  #   @qty_index
  # end

  def invoice
    Invoice.all.find{|invoice| invoice.id == self.invoice_id}
  end

  def item
    Item.all.find{|item| item.id == self.item_id}
  end

  # def line_item_revenue
  #  BigDecimal(self.quantity) * BigDecimal(self.unit_price)
  # end

end
