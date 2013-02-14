class Customer

attr_reader :id, :first_name

  def initialize(data)
    @id         = data[:id]
    @first_name = data[:first_name]
  end

end