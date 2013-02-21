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
      @data.select{|trans| trans.invoice_id == inv_id }
    end

    def self.find_by_id(id)
      @data.find{|transaction| transaction.id == id}
    end

    def self.find_by_credit_card_number(cc_num)
      @data.find {|trans| trans.credit_card_number == cc_num }
    end

    def self.find_all_by_result(result)
      @data.select{|trans| trans.result == result }
    end

    def invoice
      invoice = Invoice.all.find{|invoice| invoice.id == self.invoice_id}
    end

    def self.extract_unpaid_transactions(results)
      results.select do |invoice_id, good_trans|
        good_trans == 0
      end
    end

  end
end
