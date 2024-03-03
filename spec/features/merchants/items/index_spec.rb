require 'rails_helper'

RSpec.describe 'merchant items index', type: :feature do
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

    # 6. Merchant Items Index Page
    it 'displays a merchants items' do
      # When I visit my merchant items index page (merchants/:merchant_id/items)
      visit merchant_items_path(@merch_1)
      # I see a list of the names of all of my items
      within '.merch-items' do
        expect(page).to have_content(@item_1.name)
      end
      # And I do not see items for any other merchant
      expect(page).to_not have_content(@item_2.name)
    end

    # 9. Merchant Item Disable/Enable
    it "can enable or disable each item with a button" do 
      # When I visit my items index page (/merchants/:merchant_id/items)
      visit merchant_items_path(@merch_1)

      within "#enabled-item-#{@item_3.id}" do
        # Next to each item name I see a button to disable or enable that item.
        expect(page).to_not have_button("enable")
        expect(page).to have_button("disable")
        # When I click this button
        click_button("disable")
      end
      # Then I am redirected back to the items index
      expect(current_path).to eq(merchant_items_path(@merch_1))
      # And I see that the items status has changed
      within "#disabled-item-#{@item_1.id}" do
        expect(page).to_not have_button("disable")
        expect(page).to have_button("enable")
      end
    end

    # 10. Merchant Items Grouped by Status
    it "has sections for enabled and disabled items" do 
      # When I visit my merchant items index page
      visit merchant_items_path(@merch_1)
      # Then I see two sections, one for "Enabled Items" and one for "Disabled Items"
      # And I see that each Item is listed in the appropriate section
      within '.disabled-items' do
        expect(page).to have_content("Disabled Items:")
        expect(page).to have_link(@item_1.name)
      end
      
      within '.enabled-items' do
        expect(page).to have_content("Enabled Items:")
        expect(page).to have_link(@item_3.name)
      end
    end

    # 11. Merchant Item Create
    it "can add an item" do
      # As a merchant
      # When I visit my items index page
      visit merchant_items_path(@merch_1)
      # I see a link to create a new item.
      within '.create-item' do
        expect(page).to have_link("Create New Item")
        # When I click on the link,
        click_link("Create New Item")
      end
      #Continued in spec/features/merchants/items/new_spec.rb
    end

    # 12. Merchant Items Index: 5 most popular items
    it "displays the top 5 most popular items" do 
      test_item_1 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "1")
      test_item_2 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "2")
      test_item_3 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "3")
      test_item_4 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "4")
      test_item_5 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "5")
      test_item_6 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "6")

      test_invoice_1 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_2 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_3 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_4 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_5 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_6 = create(:invoice, customer_id: @cust_1.id)

      test_trans_1 = create(:transaction, invoice_id: test_invoice_1.id)
      test_trans_2 = create(:transaction, invoice_id: test_invoice_2.id)
      test_trans_3 = create(:transaction, invoice_id: test_invoice_3.id)
      test_trans_4 = create(:transaction, invoice_id: test_invoice_4.id)
      test_trans_5 = create(:transaction, invoice_id: test_invoice_5.id)
      test_trans_6 = create(:transaction, invoice_id: test_invoice_6.id)

      create(:invoice_item, item_id: test_item_1.id, invoice_id: test_invoice_1.id, unit_price: 1, quantity: 400)
      create(:invoice_item, item_id: test_item_2.id, invoice_id: test_invoice_2.id, unit_price: 1, quantity: 300)
      create(:invoice_item, item_id: test_item_3.id, invoice_id: test_invoice_3.id, unit_price: 1, quantity: 200)
      create(:invoice_item, item_id: test_item_4.id, invoice_id: test_invoice_4.id, unit_price: 1, quantity: 100)
      create(:invoice_item, item_id: test_item_5.id, invoice_id: test_invoice_5.id, unit_price: 1, quantity: 1)
      create(:invoice_item, item_id: test_item_6.id, invoice_id: test_invoice_6.id, unit_price: 1, quantity: 500)

      # When I visit my items index page
      visit merchant_items_path(@merch_2)
      within '.top-five-items' do
        # Then I see the names of the top 5 most popular items ranked by total revenue generated
        expect(page).to_not have_link(test_invoice_5)

        within "#item-#{test_item_6.id}" do
          # And I see that each item name links to my merchant item show page for that item
          expect(page).to have_link(test_item_6.name)
          # And I see the total revenue generated next to each item name
          expect(page).to have_content("500")
        end

        within "#item-#{test_item_1.id}" do
          # And I see that each item name links to my merchant item show page for that item
          expect(page).to have_link(test_item_1.name)
          # And I see the total revenue generated next to each item name
          expect(page).to have_content("400")
        end

        within "#item-#{test_item_2.id}" do
          # And I see that each item name links to my merchant item show page for that item
          expect(page).to have_link(test_item_2.name)
          # And I see the total revenue generated next to each item name
          expect(page).to have_content("300")
        end

        within "#item-#{test_item_3.id}" do
          # And I see that each item name links to my merchant item show page for that item
          expect(page).to have_link(test_item_3.name)
          # And I see the total revenue generated next to each item name
          expect(page).to have_content("200")
        end

        within "#item-#{test_item_4.id}" do
          # And I see that each item name links to my merchant item show page for that item
          expect(page).to have_link(test_item_4.name)
          # And I see the total revenue generated next to each item name
          expect(page).to have_content("100")

          click_link(test_item_4.name)

        end

        expect(current_path).to eq(merchant_item_path(@merch_2, test_item_4))

      end
      # Notes on Revenue Calculation:
      # - Only invoices with at least one successful transaction should count towards revenue
      # - Revenue for an invoice should be calculated as the sum of the revenue of all invoice items
      # - Revenue for an invoice item should be calculated as the invoice item unit price multiplied by the quantity (do not use the item unit price)
    end
    
    # 13. Merchant Items Index: Top Item's Best Day
    it "displays the date of the most sales for each item" do 
      test_item_1 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "1")
      test_item_2 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "2")
      test_item_3 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "3")
      test_item_4 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "4")
      test_item_5 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "5")
      test_item_6 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "6")

      test_invoice_1 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_2 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_3 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_4 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_5 = create(:invoice, customer_id: @cust_1.id)
      test_invoice_6 = create(:invoice, customer_id: @cust_1.id)

      test_trans_1 = create(:transaction, invoice_id: test_invoice_1.id)
      test_trans_2 = create(:transaction, invoice_id: test_invoice_2.id)
      test_trans_3 = create(:transaction, invoice_id: test_invoice_3.id)
      test_trans_4 = create(:transaction, invoice_id: test_invoice_4.id)
      test_trans_5 = create(:transaction, invoice_id: test_invoice_5.id)
      test_trans_6 = create(:transaction, invoice_id: test_invoice_6.id)

      create(:invoice_item, item_id: test_item_1.id, invoice_id: test_invoice_1.id, unit_price: 1, quantity: 400)
      create(:invoice_item, item_id: test_item_2.id, invoice_id: test_invoice_2.id, unit_price: 1, quantity: 300)
      create(:invoice_item, item_id: test_item_3.id, invoice_id: test_invoice_3.id, unit_price: 1, quantity: 200)
      create(:invoice_item, item_id: test_item_4.id, invoice_id: test_invoice_4.id, unit_price: 1, quantity: 100)
      create(:invoice_item, item_id: test_item_5.id, invoice_id: test_invoice_5.id, unit_price: 1, quantity: 1)
      create(:invoice_item, item_id: test_item_6.id, invoice_id: test_invoice_6.id, unit_price: 1, quantity: 500)

      # When I visit my items index page
      visit merchant_items_path(@merch_2)
      # Then next to each of the 5 most popular items I see the date with the most sales for each item.
      within '.top-five-items' do
        within "#item-#{test_item_6.id}" do
        # And I see a label “Top selling date for <item name> was <date with most sales>"
          expect(page).to have_content("#{test_item_6.name}")
          expect(page).to have_content("#{test_item_6.created_at.strftime('%A, %B, %d, %Y')}")
        end

        within "#item-#{test_item_1.id}" do
        # And I see a label “Top selling date for <item name> was <date with most sales>"
        expect(page).to have_content("#{test_item_1.name}")
        expect(page).to have_content("#{test_item_1.created_at.strftime('%A, %B, %d, %Y')}")
        end

        within "#item-#{test_item_2.id}" do
        # And I see a label “Top selling date for <item name> was <date with most sales>"
        expect(page).to have_content("#{test_item_2.name}")
        expect(page).to have_content("#{test_item_2.created_at.strftime('%A, %B, %d, %Y')}")
        end

        within "#item-#{test_item_3.id}" do
        # And I see a label “Top selling date for <item name> was <date with most sales>"
        expect(page).to have_content("#{test_item_3.name}")
        expect(page).to have_content("#{test_item_3.created_at.strftime('%A, %B, %d, %Y')}")
        end

        within "#item-#{test_item_4.id}" do
        # And I see a label “Top selling date for <item name> was <date with most sales>"
        expect(page).to have_content("#{test_item_4.name}")
        expect(page).to have_content("#{test_item_4.created_at.strftime('%A, %B, %d, %Y')}")
        end
      end
      # Note: use the invoice date. If there are multiple days with equal number of sales, return the most recent day.
    end
  end
end