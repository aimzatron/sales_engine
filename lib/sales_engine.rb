require 'bigdecimal'
require 'Date'
require 'csv'

require './lib/sales_engine/item'
require './lib/sales_engine/merchant'
require './lib/sales_engine/customer'
require './lib/sales_engine/invoice_item'
require './lib/sales_engine/transaction'
require './lib/sales_engine/invoice'

require './lib/sales_engine/merchant_builder'
require './lib/sales_engine/item_builder'
require './lib/sales_engine/invoice_builder'
require './lib/sales_engine/transaction_builder'
require './lib/sales_engine/invoice_item_builder'
require './lib/sales_engine/customer_builder'

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