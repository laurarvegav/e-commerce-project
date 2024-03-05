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

    #User story I-1: Merchant Bulk Discounts Index
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

    #User Story I-3: Merchant Bulk Discount Delete
    it "displays a successful delete button next to each bulk discount" do
      # As a merchant When I visit my bulk discounts index
      visit merchant_bulk_discounts_path(@merchant_1.id)
      # Then next to each bulk discount I see a button to delete it
      within "#bulk_discount-#{@discount_m1_A.id}" do
        expect(page).to have_button("Delete")
      end
      within "#bulk_discount-#{@discount_m1_B.id}" do
        # When I click this button
        click_button("Delete")
      end
      # Then I am redirected back to the bulk discounts index page
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1.id))
      # And I no longer see the discount listed
      expect(page).not_to have_content("Bulk Discount is 30% off 15 items")
    end

    #API Extension - Holidays API
    it "displays the 3 upcoming holidays" do
      # As a merchant When I visit the discounts index page
      visit merchant_bulk_discounts_path(@merchant_1)
      # I see a section with a header of "Upcoming Holidays"
      within ".upcoming_holidays" do
        # In this section the name and date of the next 3 upcoming US holidays are listed.
        expect(page).to have_content("Upcoming US holidays:")
        expect(page).to have_content("Good Friday")
        expect(page).to have_content("Memorial Day")
        expect(page).to have_content("Juneteent")
        # Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
      end
    end

    #Holiday Dct Extension- Create a Holiday Discount
    it "allows to create a new discount named after a holiday" do
      # As a merchant, when I visit the discounts index page,
      visit merchant_bulk_discounts_path(@merchant_1)

      within ".upcoming_holidays" do
        # In the Holiday Discounts section, I see a `create discount` button next to each of the 3 upcoming holidays.
        within "#Juneteenth" do
          click_button("Create Discount")
        end
      end
      # When I click on the button I am taken to a new discount form that has the form fields auto populated with:
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1.id))
      #Discount name: <name of holiday> discount
      expect(page).to have_content("Holiday")
      #Percentage Discount: 30
      expect(find_field(:percentage_discount).value).to eq("30")
      #Quantity Threshold: 2
      expect(find_field(:quantity_treshold).value).to eq("2")
      # I can leave the information as is, or modify it before saving.
      click_button("Submit")

      # I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts.
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

      expect(page).to have_content("Discount is 30% off 2 items")
    end
  end
end