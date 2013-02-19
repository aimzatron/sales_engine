require 'csv'
require './lib/item'

class ItemBuilder

  DEFAULT_FILE = "./data/items.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |item|
      Item.new(item)
    end

    merchant_index = create_merchant_index(data)
    Item.store_merchant_index(merchant_index)
    Item.store(data)
  end

  def self.create_merchant_index(data)
    data.group_by{|item| item.merchant_id}
  end

end