class Merchant < ApplicationRecord
  
  validates :name, presence: true
  validates :status, presence: true

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :discounts

  enum status: ["disabled", "enabled"]

  def top_five_cust
    customers.top_five_customers
    # customers.joins(invoices: [:transactions]) #what tables do we need
    #   .where(transactions: { result: 0 })# are there conditions for the data I want back
    #   .select("customers.*, CONCAT(customers.first_name, ' ', customers.last_name) AS full_name, COUNT(transactions.id) as successful_transactions") #select is what I want back
    #   .group('customers.id') #how do I want to organize the data
    #   .order("successful_transactions DESC")  #how the group will be returned
    #   .limit(5) #how many 
  end

  def not_shipped_invoices  
    invoices.joins(:items)
      .joins(:invoice_items)
      .where.not(invoice_items: { status: 2 })
      .select('invoices.*, items.name AS item_name')
      .order('invoices.created_at') #
  end

  def enabled?
    self.status == "enabled"
  end

  def self.top_five_merchants
    Merchant.select("merchants.name, merchants.id, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:transactions)
    .where("transactions.result = ?", "0")
    .group("merchants.id")
    .limit(5)
    .order("revenue DESC")
  end

  def revenue_to_dollars
    self.revenue/100
  end

  def top_revenue_day
    Merchant.select("merchants.id, (invoice_items.quantity * invoice_items.unit_price) AS day_revenue, invoices.created_at")
    .joins(:transactions)
    .where("transactions.result = ?", "0")
    .order("day_revenue DESC")
    .order("invoice_date DESC")
    .group("invoices.created_at, merchants.id, day_revenue")
    .select("invoices.created_at AS invoice_date")
    .where("merchants.id = #{self.id}")
    .first.invoice_date
  end
end