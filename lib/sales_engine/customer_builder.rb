module SalesEngine
  class CustomerBuilder

    DEFAULT_FILE = "./data/customers.csv"
    DATA_REPOSITORY = Customer

    def self.parse_csv(file = DEFAULT_FILE, repo=DATA_REPOSITORY)
      contents = CSV.open(file, headers: true, header_converters: :symbol)

      data = contents.collect do |c|
        cust_hash = c.to_hash.merge(id: c[:id].to_i)
        repo.new(cust_hash)
      end
      repo.store(data)
    end

  end
end