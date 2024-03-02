require 'rails_helper'

RSpec.describe 'Edit Merchant Bulk Discount', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merchant_1 = create(:merchant, name: "Amazon", status: 0) 
      @discount_m1_A = BulkDiscount.create!(percentage_discount: 20, quantity_treshold: 10, merchant_id: @merchant_1.id)
      @discount_m1_B = BulkDiscount.create!(percentage_discount: 30, quantity_treshold: 15, merchant_id: @merchant_1.id)
    end

    #Continued: User Story I-5: 5: Merchant Bulk Discount Edit
    it "displays edit button" do
      visit edit_merchant_bulk_discount_path(@merchant_1.id, @discount_m1_A)
      # And I see that the discounts current attributes are pre-poluated in the form
      expect(page).to have_field("Quantity treshold")
      expect(page).to have_content("Percentage discount")
      # When I change any/all of the information and click submit
      fill_in(:quantity_treshold, with: "7")
      click_button("Submit")
      # Then I am redirected to the bulk discount's show page
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_m1_A))
      # And I see that the discount's attributes have been updated
      expect(page).to have_content("The information has been successfully updated for the discount")
      expect(page).to have_content("Bulk Discount is 20% off 7 items")
    end
    
    it "flashes error message when field is submitted with incorrect information" do
      visit edit_merchant_bulk_discount_path(@merchant_1.id, @discount_m1_A)
      fill_in(:quantity_treshold, with: "five")
      click_button("Submit")
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1.id, @discount_m1_A))
      expect(page).to have_content("Error: Quantity treshold is not a number")
    end
  end
end