require 'csv'
require './lib/customer'

class CustomerBuilder

  DEFAULT_FILE = "./data/customers.csv"

  def self.parse_csv(file = DEFAULT_FILE)
    contents = CSV.open(file, headers: true, header_converters: :symbol)

    data = contents.collect do |customer|
      Customer.new(customer)
    end

    Customer.store(data)
  end

end
