module SalesEngine
  class InvoiceItem

    attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price,
                :line_revenue, :created_at, :updated_at

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

    def self.find_by_item_id(item_id)
      @data.find{|invoice_item| invoice_item.item_id == item_id}
    end

    def self.find_by_id(id)
      @data.find{|invoice_item| invoice_item.id == id}
    end

    def self.find_all_by_quantity(quantity)
      @data.select{|invoice_item| invoice_item.quantity == quantity}
    end

    def invoice
      Invoice.all.find{|invoice| invoice.id == self.invoice_id}
    end

    def item
      Item.all.find{|item| item.id == self.item_id}
    end

    def self.random
      @data.sample
    end

    def self.paid_invoice_items(ii)
      paid_invoice_items_list = Transaction.get_paid_invoice_list
      exit if ii.nil?
      ii.inject([]) do |memo, inv_item|
        if paid_invoice_items_list.include?(inv_item.invoice_id)
          memo << inv_item
        end
        memo
      end
    end
  end
end
