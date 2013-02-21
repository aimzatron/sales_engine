module SalesEngine
  class ItemBuilder

    DEFAULT_FILE = "./data/items.csv"
    DATA_REPOSITORY = Item

    def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = contents.collect do |item|
        item_hash = item.to_hash.merge({id: item[:id].to_i,
          merchant_id: item[:merchant_id].to_i,
          unit_price: BigDecimal.new(item[:unit_price]) / 100})

        repo.new(item_hash)
      end

      customer_index = index_by(:merchant_id, data, repo)
      repo.store(data)
    end

    def self.index_by(attribute, data, repo)
      index = data.group_by { |invoice| invoice.send(attribute) }
      repo.store_index(attribute, index)
    end

  end
end
