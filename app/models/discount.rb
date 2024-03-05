class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant

  validates :percent_discount, presence: true
  validates :quantity_threshold, presence: true
end