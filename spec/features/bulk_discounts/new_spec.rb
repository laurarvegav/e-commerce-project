require 'rails_helper'

RSpec.describe 'New bulk discount page', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merchant_1 = create(:merchant, name: "Amazon", status: 0) 
      @merchant_2 = create(:merchant, name: "Walmart", status: 0) 
      @merchant_3 = create(:merchant, name: "Apple", status: 0) 
      @merchant_4 = create(:merchant, name: "Microsoft", status: 0) 
      @merchant_5 = create(:merchant, name: "Petco", status: 1) 
      @merchant_6 = create(:merchant, name: "Aetna", status: 1) 
      @merchant_7 = create(:merchant, name: "Adidas", status: 1) 

      @discount_m1_A = BulkDiscount.create!(percentage_discount: 20, quantity_treshold: 10, merchant_id: @merchant_1.id)
      @discount_m1_B = BulkDiscount.create!(percentage_discount: 30, quantity_treshold: 15, merchant_id: @merchant_1.id)
    end

    # Continued User Story I-2. 2: Merchant Bulk Discount Create
    it "displays a form to create a new discount and adds it succesfully" do
      # I see a form to add a new bulk discount
      visit new_merchant_bulk_discount_path(@merchant_1.id)
      # When I fill in the form with valid data
      fill_in("Percentage discount", with: 10)
      fill_in("Quantity treshold", with: 5)
      click_button("Submit")
      # Then I am redirected back to the bulk discount index
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1.id))
      # And I see my new bulk discount listed
      expect(page).to have_content("Bulk Discount is 10% off 5 items")
    end

    it "flashes error message when field is submitted empty" do
      visit new_merchant_bulk_discount_path(@merchant_1.id)
      fill_in("Percentage discount", with:"")
      fill_in("Quantity treshold", with: 5)
      click_button("Submit")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1.id))
      expect(page).to have_content("Error: Percentage discount can't be blank")
    end

    it "flashes error message when field is submitted with incorrect information" do
      visit new_merchant_bulk_discount_path(@merchant_1.id)
      fill_in("Percentage discount", with:10)
      fill_in("Quantity treshold", with: "five")
      click_button("Submit")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1.id))
      expect(page).to have_content("Error: Quantity treshold is not a number")
    end
  end
end