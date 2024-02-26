class Item < ApplicationRecord
  
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  belongs_to :merchant 
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum status: ["disabled", "enabled"]

  def self.enabled_items
    where(status: :enabled)
  end

  def self.disabled_items
    where(status: :disabled)
  end

  def self.top_five_items
    # items/invoice_items/invoices/transactions
    # we are returning item obejcts
    self.joins(:invoice_items, :invoices, :transactions)
      .where(transactions: { result: 0 })
      .select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
      .group("items.id")
      .order("total_revenue DESC")
      .limit(5)
  end

  def date_with_most_sales
    # require 'pry'; binding.pry
    # self.invoice_items.joins(:invoice)
    #   .select("invoices.*")
    #   .group("SUM(invoices_items.created_at) DESC")
    #   .limit(1)
      self.invoices
      .group('DATE(invoices.created_at)')
      .order('COUNT(invoices.id) DESC')
      .limit(1)
      .pluck('DATE(invoices.created_at)')
      .first
  end
end
