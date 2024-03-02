require 'rails_helper'

RSpec.describe 'Bulk discounts index page', type: :feature do
  describe 'As a merchant' do
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

    #User story 1: Merchant Bulk Discounts Index
    it 'displays all bulk  discounts and its attributes, with a link to its own show page' do
      visit dashboard_merchant_path(@merchant_1)
      click_link("View All #{@merchant_1.name} Discounts")
      within "#bulk_discount-#{@discount_m1_A.id}" do
        # Where I see all of my bulk discounts including their percentage discount and quantity thresholds
        expect(page).to have_content("Bulk Discount is 20% off 10 items")
        # And each bulk discount listed includes a link to its show page
        expect(page).to have_link("Discount Details")
      end
      within "#bulk_discount-#{@discount_m1_B.id}" do
        expect(page).to have_content("Bulk Discount is 30% off 15 items")
        expect(page).to have_link("Discount Details")
      end
    end   

    # User Story I-2. 2: Merchant Bulk Discount Create
    it "displays link to create a new discount" do
      # As a merchant, when I visit my bulk discounts index
      visit merchant_bulk_discounts_path(@merchant_1.id)
      # Then I see a link to create a new discount
      expect(page).to have_link(href: new_merchant_bulk_discount_path(@merchant_1.id))
      # When I click this link
      click_link("Create New Discount")
      # Then I am taken to a new page where I see a form to add a new bulk discount
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1.id))
      #Continued in spec/features/bulk_discounts/new_spec.rb
    end
  end
end