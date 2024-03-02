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

  def self.net_revenue
    brute_revenue - discounts
  end

  def self.brute_revenue
    total_revenue_in_cents = Invoice
      .joins(:invoice_items)
      .group("invoices.id")
      .pluck(Arel.sql("sum(invoice_items.unit_price * invoice_items.quantity) as revenue"))
      .sum

    total_revenue_in_cents/100
  end

  def self.discounts
    Invoice.joins(merchants: :bulk_discounts).joins(items: :invoice_items)
      .select("merchants.id, bulk_discounts.*, items.*, invoice_items.*")
      .where("merchants.id = items.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_treshold")
      .group("invoices.id, bulk_discounts.id, items.id, invoice_items.id").pluck(Arel.sql("invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.percentage_discount/100)")).sum
    # require 'pry'; binding.pry
    # Merchant.joins(items: :invoice_items).joins(:bulk_discounts)
  end
end
