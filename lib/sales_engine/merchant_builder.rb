module SalesEngine
  class MerchantBuilder

    DEFAULT_FILE = "./data/merchants.csv"

    def self.parse_csv(file = DEFAULT_FILE)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = contents.collect do |merchant|
        merch_hash = merchant.to_hash.merge(id: merchant[:id].to_i)
        Merchant.new(merch_hash)
      end

      Merchant.store(data)
    end
  end
end