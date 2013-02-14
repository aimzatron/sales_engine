# Address circular dependency issue (where two files require each other)

require 'csv'
#require './lib/merchant'

class MerchantBuilder

  def self.parse_csv(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    @data = contents.collect do |merchant|
      merchant_hash = {}
      merchant_hash[:id] = merchant[:id]
      merchant_hash[:name] = merchant[:name]
      merchant_hash[:created_at] = merchant[:created_at]
      merchant_hash[:updated_at] = merchant[:updated_at]

      Merchant.new(merchant_hash)
    end
    #return data
  end

  def self.data
    @data ||= self.parse_csv("./test/support/merchant_build.csv")
  end

end

#puts MerchantBuilder.data.inspect
