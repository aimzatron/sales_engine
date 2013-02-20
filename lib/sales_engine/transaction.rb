module SalesEngine
  class Transaction

    attr_reader :id, :invoice_id, :credit_card_number,
                :credit_card_expiration_date, :result, :created_at, :updated_at

    def initialize(data)
      @id = data[:id]
      @invoice_id = data[:invoice_id]
      @credit_card_number = data[:credit_card_number]
      @credit_card_expiration_date = data[:credit_card_expiration_date]
      @result = data[:result]
      @created_at = data[:created_at]
      @updated_at = data[:updated_at]
    end

    def self.store(transactions)
      @data = transactions
    end

    def self.all
      @data
    end

    def self.random
      @data.sample
    end

    def self.store_index(attribute, index_data)
      @indexes ||= {}
      @indexes[attribute.to_sym] = index_data
    end

    def self.get_index(attribute)
      @indexes[attribute]
    end

    def self.store_paid_invoice_list(list)
      @paid_invoice_list = list
    end

    def self.get_paid_invoice_list
      @paid_invoice_list
    end

    def self.find_all_by_invoice_id(inv_id)
      @data.select { |trans| trans.invoice_id.to_i == inv_id }
    end

    def self.find_by_credit_card_number(cc_num)
      @data.find {|trans| trans.credit_card_number == cc_num }
    end

    def invoice
      invoice = Invoice.all.find{|invoice| invoice.id == self.invoice_id}
    end

    # def self.pending
    #  results = group_transactions_by_invoice_id
    #  puts results.inspect
    #  #unpaid = extract_unpaid_transactions(results)
    #  #puts unpaid.inspect
    # end

    # def self.group_transactions_by_invoice_id
    #   @data.inject(Hash.new(0)) do |pending, t|
    #     if t.result == "success"
    #       pending[t.invoice_id] += 1
    #     else
    #       pending[t.invoice_id] += 0
    #     end
    #     pending
    #   end
    # end

    def self.extract_unpaid_transactions(results)
      results.select do |invoice_id, good_trans|
        good_trans == 0
      end
    end

  end
end