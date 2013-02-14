require 'csv'
require './lib/item'

class ItemBuilder

  def self.parse_csv(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    @data = contents.collect do |item|
      item_hash               = {}
      item_hash[:id]          = item[:id]
      item_hash[:name]        = item[:name]
      item_hash[:description] = item[:description]
      item_hash[:unit_price]  = item[:unit_price]
      item_hash[:merchant_id] = item[:merchant_id]
      item_hash[:created_at]  = item[:created_at]
      item_hash[:updated_at]  = item[:updated_at]

      Item.new(item_hash)
    end
  end

end