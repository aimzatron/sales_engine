require 'csv'
require './lib/customer'

class CustomerBuilder

  def self.parse_csv(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    @data = contents.collect do |customer|
      customer_hash = {}
      customer_hash[:id] = customer[:id]
      customer_hash[:first_name] = customer[:first_name]
      customer_hash[:last_name] = customer[:last_name]
      customer_hash[:created_at] = customer[:created_at]
      customer_hash[:updated_at] = customer[:updated_at]

      Customer.new(customer_hash)
    end
  end

end

# returned_info =  CustomerBuilder.parse_csv("./test/support/customer_build.csv")

# puts returned_info.inspect
