class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id
  
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: ["in progress", "cancelled", "completed"]
  
  # class method for checking status of invoice
  def self.invoices_with_unshipped_items
    select("invoices.*").joins(:invoice_items).where("invoice_items.status != 2")
  end

  def self.oldest_to_newest
    order("invoices.created_at")
  end

  def self.invoices_with_unshipped_items_oldest_to_newest
    invoices_with_unshipped_items.oldest_to_newest
  end

  def total_revenue_dollars
    invoice_items.sum("quantity * unit_price")/100.00
  end
  
  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end
  
  def self.brute_revenue
    total_revenue_in_cents = joins(:invoice_items)
      .group("invoices.id")
      .pluck(Arel.sql("sum(invoice_items.unit_price * invoice_items.quantity) as revenue"))
      .sum
    
    total_revenue_in_cents/100
  end
  
  def self.net_revenue 
    eligible_discounts = all.map(&:eligible_discount)
    max_discount = eligible_discounts.max || 0
    (brute_revenue * (1 - max_discount)).round(0)
  end

  def eligible_discount
    quantity = invoice_items.sum(:quantity)
    total_discount = merchants.sum { |merchant| merchant.eligible_discount(quantity) || 0}
    total_discount = [total_discount, 100].min / 100.0
  end
end
