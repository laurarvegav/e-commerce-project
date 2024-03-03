class Item < ApplicationRecord
  
  validates_presence_of :name, 
                        :description, 
                        :unit_price

  belongs_to :merchant 
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum status: ["disabled", "enabled"]

  before_create :set_default_status
  
  def self.enabled_items
    where(status: :enabled)
  end

  def self.disabled_items
    where(status: :disabled)
  end

  def self.top_five_items
    self.joins(:invoice_items, :invoices, :transactions)
      .where(transactions: { result: 0 })
      .select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
      .group("items.id")
      .order("total_revenue DESC")
      .limit(5)
  end

  def date_with_most_sales
      self.invoices
      .group('DATE(invoices.created_at)')
      .order('COUNT(invoices.id) DESC')
      .limit(1)
      .pluck('DATE(invoices.created_at)')
      .first
  end

  def current_invoice_item(item, invoice)
    self.invoice_items
      .where(item_id: item.id, invoice_id: invoice.id).first
  end

  private
  def set_default_status
    self.status ||= 0
  end
end
