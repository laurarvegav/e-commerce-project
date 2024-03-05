require 'rails_helper'

RSpec.describe 'merchants dashboard', type: :feature do
  describe 'As a merchant' do
    before(:each) do
      @cust_1 = create(:customer)
      @cust_2 = create(:customer)
      @cust_3 = create(:customer)
      @cust_4 = create(:customer)
      @cust_5 = create(:customer)
      @cust_6 = create(:customer)
      
      @invoice_1 = create(:invoice, customer_id: @cust_1.id)
      @invoice_2 = create(:invoice, customer_id: @cust_2.id)
      @invoice_3 = create(:invoice, customer_id: @cust_3.id)
      @invoice_4 = create(:invoice, customer_id: @cust_4.id)
      @invoice_5 = create(:invoice, customer_id: @cust_6.id, created_at: "Thu, 22 Feb 2024 22:05:45.453230000 UTC +00:00")
      @invoice_6 = create(:invoice, customer_id: @cust_5.id, created_at: "Wed, 21 Feb 2024 22:05:45.453230000 UTC +00:00")
      
      @trans_1 = create(:transaction, invoice_id: @invoice_1.id)
      @trans_2 = create(:transaction, invoice_id: @invoice_2.id)
      @trans_3 = create(:transaction, invoice_id: @invoice_3.id)
      @trans_4 = create(:transaction, invoice_id: @invoice_4.id)
      @trans_5 = create(:transaction, invoice_id: @invoice_5.id)
      @trans_6 = create(:transaction, invoice_id: @invoice_6.id)
      
      @merch_1 = create(:merchant, name: "Amazon") 
      @discount_m1_A = BulkDiscount.create!(percentage_discount: 20, quantity_treshold: 10, merchant_id: @merch_1.id)
      @discount_m1_B = BulkDiscount.create!(percentage_discount: 30, quantity_treshold: 15, merchant_id: @merch_1.id)

      @item_1 = create(:item, unit_price: 1, merchant_id: @merch_1.id)

      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, unit_price: 1, quantity: 100, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_2.id, unit_price: 1, quantity: 80, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_3.id, unit_price: 1, quantity: 60, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_4.id, unit_price: 1, quantity: 50, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_5.id, unit_price: 1, quantity: 40)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_6.id, unit_price: 1, quantity: 5)
    end

    # 1. Merchant Dashboard
    it 'displays merchant name' do
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      visit dashboard_merchant_path(@merch_1)
      # Then I see the name of my merchant
      within '.merchant-info' do
        expect(page).to have_content(@merch_1.name)
      end
    end
    
    # 2. Merchant Dashboard Links
    it 'has clickable links' do
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      visit dashboard_merchant_path(@merch_1)

      within '.links' do 
        # Then I see link to my merchant items index (/merchants/:merchant_id/items)
        expect(page).to have_link("Merchant Items")
        # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
        expect(page).to have_link("Merchant Invoice Items")
      end
    end

    # 3. Merchant Dashboard Statistics - Favorite Customers
    xit "displays top customers and their successful transation count" do 
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      visit dashboard_merchant_path(@merch_1.id)
      # Then I see the names of the top 5 customers
      # who have conducted the largest number of successful transactions with my merchant
      within '.top-five' do
        # And next to each customer name I see the number of successful transactions they have conducted with my merchant
        # save_and_open_page
        within "#customer-#{@cust_1.id}" do
          expect(page).to have_content("#{@cust_1.first_name} #{@cust_1.last_name}")
          expect(page).to have_content("Successful Transaction(s): 1")
        end
        within "#customer-#{@cust_2.id}" do
          expect(page).to have_content("#{@cust_2.first_name} #{@cust_2.last_name}")
          expect(page).to have_content("Successful Transaction(s): 1")
        end
        within "#customer-#{@cust_3.id}" do
          expect(page).to have_content("#{@cust_3.first_name} #{@cust_3.last_name}")
          expect(page).to have_content("Successful Transaction(s): 1")
        end
        within "#customer-#{@cust_4.id}" do
          expect(page).to have_content("#{@cust_4.first_name} #{@cust_4.last_name}")
          expect(page).to have_content("Successful Transaction(s): 1")
        end
        within "#customer-#{@cust_5.id}" do
          expect(page).to have_content("#{@cust_5.first_name} #{@cust_5.last_name}")
          expect(page).to have_content("Successful Transaction(s): 1")
        end
      end
    end

    # 4. Merchant Dashboard Items Ready to Ship
    it "has a list of shipable items" do 
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      visit dashboard_merchant_path(@merch_1.id)
      # Then I see a section for "Items Ready to Ship"
      within '.shipable-items' do
        # In that section I see a list of the names of all of my items that
        # have been ordered and have not yet been shipped,
        
        within "#invoice-#{@invoice_6.id}" do
          # And next to each Item I see the id of the invoice that ordered my item
          # And each invoice id is a link to my merchant's invoice show page
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@invoice_6.id)
        end
      end
    end

    # 5. Merchant Dashboard Invoices sorted by least recent
    it "it displays the created date for invoices and lists them oldest to newest" do 
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      visit dashboard_merchant_path(@merch_1.id)
      # In the section for "Items Ready to Ship",
      within '.shipable-items' do
        # Next to each Item name I see the date that the invoice was created
        within "#invoice-#{@invoice_5.id}" do
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@invoice_5.id)
          # And I see the date formatted like "Monday, July 18, 2019"
          expect(page).to have_content(@invoice_5.created_at.strftime('%A, %B, %d, %Y'))
          # And I see that the list is ordered from oldest to newest
        end

        within "#invoice-#{@invoice_6.id}" do
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@invoice_6.id)
          # And I see the date formatted like "Monday, July 18, 2019"
          expect(page).to have_content(@invoice_6.created_at.strftime('%A, %B, %d, %Y'))
          # And I see that the list is ordered from oldest to newest
        end

        expect(@invoice_6.created_at.strftime('%A, %B, %d, %Y')).to appear_before(@invoice_5.created_at.strftime('%A, %B, %d, %Y'))
      end
    end

    #User story I-1: Merchant Bulk Discounts Index
    it "displays links to view all bulk discounts that takes me to bulk discount index page" do
      # As a merchant
      # When I visit my merchant dashboard
      visit dashboard_merchant_path(@merch_1)
      # Then I see a link to view all my discounts
      within "#bulk_discounts" do
        # When I click this link
        click_link("View All #{@merch_1.name} Discounts")
        # Then I am taken to my bulk discounts index page
        expect(current_path).to eq(merchant_bulk_discounts_path(@merch_1.id))
      end
      #Continued in spec/features/bulk_discounts/index_spec.rb
    end
  end
end
