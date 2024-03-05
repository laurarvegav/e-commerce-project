require 'rails_helper'

RSpec.describe 'merchant invoice index', type: :feature do
  describe 'as a merchant' do
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

      @item_1 = create(:item, unit_price: 1, merchant_id: @merch_1.id)
      @item_3 = create(:item, unit_price: 1, merchant_id: @merch_1.id, status: 1)
      @item_2 = create(:item, unit_price: 1, merchant_id: @merch_2.id)

      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, unit_price: 1, quantity: 100, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_2.id, unit_price: 1, quantity: 80, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_3.id, unit_price: 1, quantity: 60, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_4.id, unit_price: 1, quantity: 50, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_5.id, unit_price: 1, quantity: 40)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_6.id, unit_price: 1, quantity: 5)
    end

    # 14. Merchant Invoices Index
    it "displays invoices with the merchant item" do
      # As a merchant,
      # When I visit my merchant's invoices index (/merchants/:merchant_id/invoices)
      visit merchant_invoices_path(@merch_1)
      # Then I see all of the invoices that include at least one of my merchant's items
      # And for each invoice I see its id
      within '.invoices' do
        within "#invoice-#{@invoice_1.id}" do
          expect(page).to have_link(@invoice_1.id)
        end

        within "#invoice-#{@invoice_2.id}" do
          expect(page).to have_link(@invoice_2.id)
        end 

        within "#invoice-#{@invoice_3.id}" do
          expect(page).to have_link(@invoice_3.id)
        end 

        within "#invoice-#{@invoice_4.id}" do
          expect(page).to have_link(@invoice_4.id)
        end 

        within "#invoice-#{@invoice_5.id}" do
          expect(page).to have_link(@invoice_5.id)
        end 

        within "#invoice-#{@invoice_6.id}" do
          expect(page).to have_link(@invoice_6.id)
          click_on(@invoice_6.id)
        end 
        expect(current_path).to eq(merchant_invoice_path(@merch_1, @invoice_6))
      end
      # And each id links to the merchant invoice show page
    end
  end 
end 