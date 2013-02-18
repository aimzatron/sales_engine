require 'bigdecimal'

class InvoiceItem

  attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price, :line_item_total, :created_at, :updated_at

  def initialize(data)
    @id         = data[:id]
    @item_id    = data[:item_id]
    @invoice_id = data[:invoice_id]
    @quantity   = data[:quantity]
    @unit_price = data[:unit_price]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.store(invoice_items)
    @data = invoice_items
  end

  def self.all
    @data
  end

  def invoice
    Invoice.all.find{|invoice| invoice.id == self.invoice_id}
  end

  def item
    Item.all.find{|item| item.id == self.item_id}
  end

  def line_item_revenue
   BigDecimal(self.quantity) * BigDecimal(self.unit_price)
  end

end
