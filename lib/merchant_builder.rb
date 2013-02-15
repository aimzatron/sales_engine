require 'csv'
require './lib/merchant'

class MerchantBuilder

  DEFAULT_FILE = "./data/merchants.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |merchant|
      Merchant.new(merchant)
    end

    Merchant.store(data)
  end
end