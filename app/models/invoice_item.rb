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
end
