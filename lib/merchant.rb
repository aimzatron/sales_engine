class Merchant

  attr_reader :id, :name, :created_at, :updated_at

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
  end

  def self.store(merchants)
    @data = merchants
  end

  def self.all
    @data
  end

  def self.find_by_name(name)
    @data.find {|merchant| merchant.name.downcase == name.downcase}
  end

  def self.find_all_by_name(name)
    @data.select{|merchant| merchant.name.downcase == name.downcase}
  end

  def self.find_by_id(id)
    @data.find {|merchant| merchant.id.downcase == id.downcase}
  end

  def self.find_all_by_id(id)
    @data.select{|merchant| merchant.id.downcase == id.downcase}
  end

  def self.random
    @data.sample
  end

end
