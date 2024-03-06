class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, 
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  
  enum status: ["pending", "packaged", "shipped"]

  def unit_price_to_dollars
    unit_price/100.00
  end

  def brute_revenue
    quantity * unit_price_to_dollars
  end

  def net_revenue 
     brute_revenue * (1 - disct_to_apply).round(2)
  end

  def disct_to_apply
    item.merchant.eligible_discount(quantity)/100.0
  end
end
