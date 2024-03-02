require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merchant_1 = create(:merchant, name: "Amazon", status: 0) 
      @discount_m1_A = BulkDiscount.create!(percentage_discount: 20, quantity_treshold: 10, merchant_id: @merchant_1.id)
      @discount_m1_B = BulkDiscount.create!(percentage_discount: 30, quantity_treshold: 15, merchant_id: @merchant_1.id)
    end

    # User Story I-4: Merchant Bulk Discount Show
    it 'displays the bulk discounts quantity threshold and percentage discount' do
      # As a merchant When I visit my bulk discount show page
      visit merchant_bulk_discount_path(@merchant_1, @discount_m1_A)
      # Then I see the bulk discount's quantity threshold and percentage discount
      expect(page).to have_content("Bulk Discount is 20% off 10 items")
    end

    # User Story I-5: 5: Merchant Bulk Discount Edit
    it "displays edit button" do
      # As a merchant When I visit my bulk discount show page
      visit merchant_bulk_discount_path(@merchant_1, @discount_m1_A)
      # Then I see a link to edit the bulk discount, When I click this link
      click_link("Edit Bulk Discount")
      # Then I am taken to a new page with a form to edit the discount
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1.id, @discount_m1_A))
      # Continued in spec/features/bulk_discounts/edit_spec.rb
    end
  end
end