require 'csv'
require './lib/item'

class ItemBuilder

  DEFAULT_FILE = "./data/items.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |item|
      Item.new(item)
    end

    Item.store(data)
  end

end