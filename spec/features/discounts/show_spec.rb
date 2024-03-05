require 'rails_helper'

RSpec.describe "Discounts#index", type: :feature do
  before(:each) do
    @merch_1 = create(:merchant, name: "Amazon") 

    @discount_1 = @merch_1.discounts.create!(percent_discount: 20, quantity_threshold: 10)
    @discount_2 = @merch_1.discounts.create!(percent_discount: 10, quantity_threshold: 5)
  end

  # 4: Merchant Bulk Discount Show
  it "discount show page" do
    # As a merchant
    # When I visit my bulk discount show page
    visit merchant_discount_path(@merch_1, @discount_1)
   # Then I see the bulk discount's quantity threshold and percentage discount
    expect(page).to have_content(@discount_1.percent_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
  end
end 