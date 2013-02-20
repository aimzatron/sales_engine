module SalesEngine
  class InvoiceItemBuilder

    DEFAULT_FILE = "./data/invoice_items.csv"
    DATA_REPOSITORY = InvoiceItem

    def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = contents.collect do |ii|
        #puts ii.class

        ii_hash = ii.to_hash.merge({line_revenue: BigDecimal.new(ii[:quantity].to_i * ii[:unit_price].to_i) / 100,
          id: ii[:id].to_i, item_id: ii[:item_id].to_i, invoice_id: ii[:invoice_id].to_i,
          quantity: ii[:quantity].to_i})

        repo.new(ii_hash)
      end

      invoice_index = index_by(:invoice_id, data, repo)
      item_index    = index_by(:item_id, data, repo)

      invoice_revenue_index = create_invoice_revenue_index(invoice_index)
      repo.store_index(:invoice_revenue, invoice_revenue_index)

      invoice_qty_index = create_invoice_qty_index(invoice_index)
      repo.store_index(:invoice_qty, invoice_qty_index)

      item_revenue_index = create_item_revenue_index(item_index)
      repo.store_index(:item_revenue, item_revenue_index)

      item_qty_index = create_item_qty_index(item_index)
      repo.store_index(:item_qty, item_qty_index)


      #puts data.inspect
      repo.store(data)
    end

    def self.index_by(attribute, data, repo)
      index = data.group_by { |invoice_item| invoice_item.send(attribute) }
     # puts index.inspect
      repo.store_index(attribute, index)
    end


    def self.create_invoice_revenue_index(invoice_index)
      #data.group_by{|invoiceItem| invoiceItem.item_id}
      revenue_hash = Hash.new(0)

      invoice_index.each do |id, invoice_items|
        sum = 0
        invoice_items.each do |invoice_item|
          sum = sum + invoice_item.line_revenue
        end
        revenue_hash[id] = sum
      end
      revenue_hash
    end

    def self.create_item_revenue_index(item_index)
      #data.group_by{|invoiceItem| invoiceItem.item_id}
      item_hash = Hash.new(0)

      item_index.each do |id, invoice_items|
        sum = 0
        invoice_items.each do |invoice_item|
          sum = sum + invoice_item.line_revenue
        end
        item_hash[id] = sum
      end
      item_hash
    end

    def self.create_invoice_qty_index(invoice_index)
      qty_hash = Hash.new(0)

      invoice_index.each do |id, invoice_items|
        sum = 0
        invoice_items.each do |invoice_item|
          sum = sum + invoice_item.quantity.to_i
        end
        qty_hash[id] = sum
      end
      qty_hash
    end

    def self.create_item_qty_index(item_index)
      qty_hash = Hash.new(0)

      item_index.each do |id, invoice_items|
        sum = 0
        invoice_items.each do |invoice_item|
          sum = sum + invoice_item.quantity.to_i
        end
        qty_hash[id] = sum
      end
      qty_hash
    end


  end
end
