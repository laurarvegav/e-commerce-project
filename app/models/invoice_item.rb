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

  def self.discounts
    joins(item: { merchant: :bulk_discounts })
    .select(
      "invoice_items.item_id,
       invoice_items.quantity,
       invoice_items.unit_price,
       bulk_discounts.quantity_threshold,
       bulk_discounts.percentage_discount,
       CASE
         WHEN invoice_items.quantity >= bulk_discounts.quantity_treshold THEN
           invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.percentage_discount / 100)
         ELSE
           invoice_items.quantity * invoice_items.unit_price
       END AS discounted_price"
    )
  end
end
