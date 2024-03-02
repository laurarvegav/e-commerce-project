class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount,
                        :quantity_treshold

  validates_numericality_of :percentage_discount,
                        :quantity_treshold

  belongs_to :merchant
end
