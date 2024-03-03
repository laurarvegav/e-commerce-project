require 'rails_helper'

RSpec.describe 'Merchant Items New Page', type: :feature do
 describe 'As an admin' do
  before(:each) do
    @merch = create(:merchant, name: "Amazon") 
    @item_1 = create(:item, unit_price: 1, merchant_id: @merch.id)
    @item_3 = create(:item, unit_price: 1, merchant_id: @merch.id, status: 1)
  end

  # User Story# 11. Continued: Merchant Item Create
  it 'shows a form to create a new merchant item with a default status, and returns to the merchant item show page where it is displayed with the entered info and default status' do
    visit new_merchant_item_path(@merch)
    # Renders form that allows me to add item information.
    # When I fill out the form I click ‘Submit’
    fill_in "name", with: "Luis"
    fill_in "description", with: "Hola"
    fill_in "unit_price", with: 0
    click_on "Submit"
    # Then I am taken back to the merchant items index page
    expect(current_path).to eq(merchant_items_path(@merch))
    # And I see the item I just created displayed with a default status of disabled.
    within '.disabled-items' do
      expect(page).to have_content("Luis")
      # And I see my item was created with a default status of disabled.
    end
  end

    #Sad path testing for user story #11
    it "responds to incomplete information in the form" do
      visit new_merchant_item_path(@merch)
      fill_in "name", with: ""
      fill_in "description", with: "Hola"
      fill_in "unit_price", with: 0
    
      click_button("Submit")

      expect(current_path).to eq(new_merchant_item_path(@merch))

      within "#flash" do
        expect(page).to have_content("Error: Name can't be blank")
      end
    end
  end
end