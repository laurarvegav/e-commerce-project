# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Merchant.destroy_all
Discount.destroy_all
Item.destroy_all
InvoiceItem.destroy_all
Transaction.destroy_all
Customer.destroy_all
Invoice.destroy_all
Rake::Task["csv_load:all"].invoke
@merch_1 = Merchant.create(name: "Amazon") 

@discount_1 = @merch_1.discounts.create!(percent_discount: 20, quantity_threshold: 10)
@discount_2 = @merch_1.discounts.create!(percent_discount: 10, quantity_threshold: 5)