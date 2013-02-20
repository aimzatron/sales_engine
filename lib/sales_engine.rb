require 'bigdecimal'
require 'Date'
require 'csv'

require 'sales_engine/item'
require 'sales_engine/merchant'
require 'sales_engine/customer'
require 'sales_engine/invoice_item'
require 'sales_engine/transaction'
require 'sales_engine/invoice'

require 'sales_engine/merchant_builder'
require 'sales_engine/item_builder'
require 'sales_engine/invoice_builder'
require 'sales_engine/transaction_builder'
require 'sales_engine/invoice_item_builder'
require 'sales_engine/customer_builder'

module SalesEngine
  def self.startup
    MerchantBuilder.parse_csv
    CustomerBuilder.parse_csv
    TransactionBuilder.parse_csv
    InvoiceItemBuilder.parse_csv
    InvoiceBuilder.parse_csv
    ItemBuilder.parse_csv
  end
end