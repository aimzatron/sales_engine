require './lib/search'
require './lib/merchant_builder'

class Merchant
  #extend Search

  attr_reader :id, :name, :created_at, :updated_at

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.all
    @data ||= MerchantBuilder.data
  end

  def self.method_missing(name, *args)
    puts "method called: #{name} is not found"
    puts "args passed in: #{args}"

    attribute = extract_attribute(name)
    args = args.join(" ")

    Search.find_by(self, attribute, args)
  end

  def self.extract_attribute(name)
    attribute = name.to_s.split("_")[2..-1].join("_")
  end




end

#m = Merchant.new({:id => '1', :name => 'Userwise', :created_at => '2012-03-23 14:53:59 UTC', :updated_at => '2012-03-27 14:53:59 UTC' })

Merchant.find_by_name("Schroeder-Jerde")

# array = Merchant.all
# puts array.inspect