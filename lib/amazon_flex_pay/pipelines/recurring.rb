module AmazonFlexPay::Pipelines #:nodoc:
  class Recurring < Base #:nodoc:
    attribute :recipient_token      # required
    attribute :transaction_amount   # required
    attribute :recurring_period     # required
    attribute :validity_expiry
    attribute :validity_start
    attribute :currency_code, :enumeration => :currency_code
    attribute :address_name
    attribute :address_line1
    attribute :address_line2
    attribute :city
    attribute :state
    attribute :zip
    attribute :country
    attribute :phone_number
    attribute :collect_shipping_address
    attribute :payment_method, :enumeration => :payment_method
    attribute :payment_reason
  end
end
