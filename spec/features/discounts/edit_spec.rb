require 'rails_helper'

RSpec.describe "Discounts#index", type: :feature do
  before(:each) do
    @merch_1 = create(:merchant, name: "Amazon") 

    @discount_1 = @merch_1.discounts.create!(percent_discount: 20, quantity_threshold: 10)
    @discount_2 = @merch_1.discounts.create!(percent_discount: 10, quantity_threshold: 5)
  end

  # 5: Merchant Bulk Discount Edit
  it "" do
    # As a merchant
    # When I visit my bulk discount show page
    visit merchant_discount_path(@merch_1, @discount_1)
    # Then I see a link to edit the bulk discount
    expect(page).to have_content("Edit Discount")
    # When I click this link
    click_link("Edit Discount")
    # Then I am taken to a new page with a form to edit the discount
    expect(current_path).to eq(edit_merchant_discount_path(@merch_1, @discount_1))
    # And I see that the discounts current attributes are pre-poluated in the form
    expect(page).to have_field("Percent discount", with: @discount_1.percent_discount)
    expect(page).to have_field("Quantity threshold", with: @discount_1.quantity_threshold)

    fill_in :percent_discount, with: 30
    fill_in :quantity_threshold, with: 10
    click_button("Update discount")
    # When I change any/all of the information and click submit
    # Then I am redirected to the bulk discount's show page
    expect(current_path).to eq(merchant_discount_path(@merch_1, @discount_1))
    # And I see that the discount's attributes have been updated
    expect(page).to have_content("30")
    expect(page).to have_content("10")
  end
end 