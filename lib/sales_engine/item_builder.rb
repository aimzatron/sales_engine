module SalesEngine
  class ItemBuilder

    DEFAULT_FILE = "./data/items.csv"
    DATA_REPOSITORY = Item

    def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = process_data(contents, repo)

      customer_index = index_by(:merchant_id, data, repo)
      repo.store(data)
    end

    def self.process_data(contents, repo)
      data = contents.collect do |i|
        item_hash = i.to_hash.merge!({id: i[:id].to_i})
        item_hash.merge!({merchant_id: i[:merchant_id].to_i})
        item_hash.merge!({unit_price: BigDecimal.new(i[:unit_price]) / 100})
        repo.new(item_hash)
      end
    end

    def self.index_by(attribute, data, repo)
      index = data.group_by { |invoice| invoice.send(attribute) }
      repo.store_index(attribute, index)
    end

  end
end
