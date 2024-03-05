require 'rails_helper'

RSpec.describe "Discounts#index", type: :feature do
  before(:each) do
    @merch_1 = create(:merchant, name: "Amazon") 

    @discount_1 = @merch_1.discounts.create!(percent_discount: 20, quantity_threshold: 10)
    @discount_2 = @merch_1.discounts.create!(percent_discount: 10, quantity_threshold: 5)
  end

    # 1: Merchant Bulk Discounts Index
  it "all discounts listed with their link to show page" do
    # As a merchant
    # When I visit my merchant dashboard
    visit dashboard_merchant_path(@merch_1)
    # Then I see a link to view all my discounts
    # When I click this link
    click_link "All Discounts"
    # Then I am taken to my bulk discounts index page
    expect(current_path).to eq(merchant_discounts_path(@merch_1))
    # Where I see all of my bulk discounts including their
    # percentage discount and quantity thresholds
    # And each bulk discount listed includes a link to its show page
    within '.all-discounts' do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link("#{@discount_1.id}")
        expect(page).to have_content(@discount_1.percent_discount)
        expect(page).to have_content(@discount_1.quantity_threshold)
      end
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_link("#{@discount_2.id}")
        expect(page).to have_content(@discount_2.percent_discount)
        expect(page).to have_content(@discount_2.quantity_threshold)
      end
    end
  end

    # 2: Merchant Bulk Discount Create
  it "new form and have the discount listed" do
    # As a merchant
    # When I visit my bulk discounts index
    visit merchant_discounts_path(@merch_1)
    # Then I see a link to create a new discount
    click_link "Create a New Discount"
    # When I click this link
    # Then I am taken to a new page where I see a form to add a new bulk discount
    expect(current_path).to eq(new_merchant_discount_path(@merch_1))
    # When I fill in the form with valid data
    fill_in "percent_discount", with: 40
    fill_in "quantity_threshold", with: 80
    click_button "Submit"
    # Then I am redirected back to the bulk discount index
    expect(current_path).to eq(merchant_discounts_path(@merch_1))
    # And I see my new bulk discount listed
    expect(page).to have_content("40")
    expect(page).to have_content("80")
  end

  # 3: Merchant Bulk Discount Delete
  it "can delete a discount" do
    # As a merchant
    # When I visit my bulk discounts index
    visit merchant_discounts_path(@merch_1)
    # Then next to each bulk discount I see a button to delete it
    # When I click this button
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_content("#{@discount_1.id}")
      expect(page).to have_button("Delete")
    click_button "Delete"
    end 
    expect(page).to_not have_content("#{@discount_1.id}")
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed
    expect(current_path).to eq(merchant_discounts_path(@merch_1))
  
    within "#discount-#{@discount_2.id}" do
      expect(page).to have_content("#{@discount_2.id}")
      expect(page).to have_button("Delete")
      click_button "Delete"
    end 
    expect(page).to_not have_content("#{@discount_2.id}")
    expect(current_path).to eq(merchant_discounts_path(@merch_1))
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