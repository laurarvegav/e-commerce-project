require 'rails_helper'

RSpec.describe 'merchant invoice show', type: :feature do
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
      @merch_2 = create(:merchant) 
      @discount_m1_A = BulkDiscount.create!(percentage_discount: 20, quantity_treshold: 10, merchant_id: @merch_1.id)
      @discount_m1_B = BulkDiscount.create!(percentage_discount: 30, quantity_treshold: 15, merchant_id: @merch_1.id)

      @item_1 = create(:item, unit_price: 1, merchant_id: @merch_1.id)
      @item_3 = create(:item, unit_price: 1, merchant_id: @merch_1.id, status: 1)
      @item_2 = create(:item, unit_price: 1, merchant_id: @merch_2.id)

      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, unit_price: 1, quantity: 100, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_2.id, unit_price: 1, quantity: 80, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_3.id, unit_price: 1, quantity: 60, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_4.id, unit_price: 1, quantity: 50, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_5.id, unit_price: 1, quantity: 40)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_6.id, unit_price: 1, quantity: 5)
      create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_6.id, unit_price: 1, quantity: 15)
    end

   
    # 15. Merchant Invoice Show Page
    it "displays invoice attributes" do
      # As a merchant
      # When I visit my merchant's invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
      visit merchant_invoice_path(@merch_1, @invoice_6)
      within '.invoice' do
        # Then I see information related to that invoice including:
        # - Invoice id
        expect(page).to have_content(@invoice_6.id)
        # - Invoice status
        expect(page).to have_content(@invoice_6.status)
        # - Invoice created_at date in the format "Monday, July 18, 2019"
        expect(page).to have_content(@invoice_6.created_at.strftime('%A, %B, %d, %Y'))
        # - Customer first and last name
        expect(page).to have_content(@invoice_6.customer.first_name)
        expect(page).to have_content(@invoice_6.customer.last_name)
      end
    end
    
    # 16. Merchant Invoice Show Page: Invoice Item Information
    it "displays invoice items" do 
      # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
      visit merchant_invoice_path(@merch_1, @invoice_6)
      within '.invoice-items' do
        # Then I see all of my items on the invoice including:
        within "#item-#{@item_1.id}" do
        # - Item name
          expect(page).to have_content(@item_1.name)
          # - The quantity of the item ordered
          expect(page).to have_content(5)
          # - The price the Item sold for
          expect(page).to have_content(1)
          # - The Invoice Item status
          expect(page).to have_content("packaged")
        end
        # And I do not see any information related to Items for other merchants
        expect(current_path).to_not eq(@item_2.name)
      end
    end

    # 17. Merchant Invoice Show Page: Total Revenue
    it "displays the total revenue" do
      # As a merchant
      # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
      visit merchant_invoice_path(@merch_1, @invoice_6)

      within "#item-#{@item_1.id}" do 
        # Then I see the total revenue that will be generated from all of my items on the invoice
        expect(page).to have_content(5)
      end
    end

    # 18. Merchant Invoice Show Page: Update Item Status
    it "can update item status" do 
      # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
      visit merchant_invoice_path(@merch_1, @invoice_6)

      within "#item-#{@item_1.id}" do 
        # I see that each invoice item status is a select field
        expect(page).to have_select("status")
        # And I see that the invoice item's current status is selected
        # When I click this select field,
        select("Enabled", from: "status")
    
        # Then I can select a new status for the Item,
        # select 'Enabled', from: 'status'
        # And next to the select field I see a button to "Update Item Status"
        expect(page).to have_content("Update Item Status")
        # When I click this button
        click_button("Update Item Status")
      end
      
      # I am taken back to the merchant invoice show page
      expect(current_path).to eq(merchant_invoice_path(@merch_1, @invoice_6))

      within "#item-#{@item_1.id}" do 
        # And I see that my Item's status has now been updated
        expect(page).to have_content("Enabled")
      end
    end

    #User Story I-7: Merchant Invoice Show Page: Link to applied discounts
    it "displays a link to the applied bulk discount to eligible invoice item" do
      # As a merchant When I visit my merchant invoice show page
      visit merchant_invoice_path(@merch_1, @invoice_6)
      # Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
      within ".invoice-items" do
        within "#item-#{@item_1.id}" do
          expect(page).not_to have_link("Details on Bulk Discount")
        end

        within "#item-#{@item_3.id}" do
          click_link("Details on Bulk Discount")
          expect(current_path).to eq(merchant_bulk_discount_path(merchant_id: @merch_1.id, id: @merch_1.b_discount(@item_3.current_invoice_item(@item_3, @invoice_6).quantity).id))
        end
      end
    end
  end 
end