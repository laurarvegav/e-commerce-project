require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before(:each) do
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_2 = create(:invoice, customer_id: @customer_2.id, created_at: "Thurs, 22 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_3 = create(:invoice, customer_id: @customer_3.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_4 = create(:invoice, customer_id: @customer_4.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_5 = create(:invoice, customer_id: @customer_5.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_6 = create(:invoice, customer_id: @customer_6.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_7 = create(:invoice, customer_id: @customer_5.id, status: 0, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_8 = create(:invoice, customer_id: @customer_5.id, status: 0, created_at: "Tues, 20 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_9 = create(:invoice, customer_id: @customer_5.id, status: 0, created_at: "Mon, 19 Feb 2024 00:47:11.096539000 UTC +00:00")

    @trans_1= create(:transaction, invoice_id: @invoice_1.id)
    @trans_2= create(:transaction, invoice_id: @invoice_1.id)
    @trans_3= create(:transaction, invoice_id: @invoice_1.id)
    @trans_4= create(:transaction, invoice_id: @invoice_1.id)
    @trans_5= create(:transaction, invoice_id: @invoice_1.id)
    @trans_6= create(:transaction, invoice_id: @invoice_2.id)
    @trans_7= create(:transaction, invoice_id: @invoice_2.id)
    @trans_8= create(:transaction, invoice_id: @invoice_2.id)
    @trans_9= create(:transaction, invoice_id: @invoice_2.id)
    @trans_10 = create(:transaction, invoice_id: @invoice_3.id)
    @trans_11 = create(:transaction, invoice_id: @invoice_3.id)
    @trans_12 = create(:transaction, invoice_id: @invoice_3.id)
    @trans_13 = create(:transaction, invoice_id: @invoice_4.id)
    @trans_14 = create(:transaction, invoice_id: @invoice_4.id)
    @trans_15 = create(:transaction, invoice_id: @invoice_5.id)
    @trans_16 = create(:transaction, invoice_id: @invoice_6.id)
    @trans_17 = create(:transaction, invoice_id: @invoice_6.id, result: 1)
    @trans_18 = create(:transaction, invoice_id: @invoice_7.id)
    @trans_19 = create(:transaction, invoice_id: @invoice_8.id)
    @trans_20 = create(:transaction, invoice_id: @invoice_9.id, result: 1)
    
    @merchant_1 = create(:merchant, name: "Amazon", status: 0) 
    @merchant_2 = create(:merchant, name: "Walmart", status: 0) 
    @merchant_3 = create(:merchant, name: "Apple", status: 0) 
    @merchant_4 = create(:merchant, name: "Microsoft", status: 0) 
    @merchant_5 = create(:merchant, name: "Petco", status: 1) 
    @merchant_6 = create(:merchant, name: "Aetna", status: 1) 
    @merchant_7 = create(:merchant, name: "Adidas", status: 1) 

    @discount_m1_A = BulkDiscount.create!(percentage_discount: 20, quantity_treshold: 10, merchant_id: @merchant_1.id)
    @discount_m1_B = BulkDiscount.create!(percentage_discount: 30, quantity_treshold: 15, merchant_id: @merchant_1.id)

    @item_1 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_2 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_3 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_4 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_5 = create(:item, unit_price: 1, merchant_id: @merchant_2.id)
    @item_6 = create(:item, unit_price: 1, merchant_id: @merchant_2.id)
    @item_7 = create(:item, unit_price: 1, merchant_id: @merchant_3.id)
    @item_8 = create(:item, unit_price: 1, merchant_id: @merchant_4.id)
    @item_9 = create(:item, unit_price: 1, merchant_id: @merchant_5.id)
    @item_10 = create(:item, unit_price: 1, merchant_id: @merchant_6.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_iem_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_iem_3 = create(:invoice_item, item_id: @item_9.id, invoice_id: @invoice_3.id, quantity: 10, unit_price: 500, status: 1)
    @invoice_iem_4 = create(:invoice_item, item_id: @item_10.id, invoice_id: @invoice_4.id, quantity: 2, unit_price: 100, status: 2)
    @invoice_iem_5 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: 78000, status: 2)
    @invoice_iem_6 = create(:invoice_item, item_id: @item_6.id, invoice_id: @invoice_7.id, quantity: 1, unit_price: 78000, status: 0)
    @invoice_iem_7 = create(:invoice_item, item_id: @item_7.id, invoice_id: @invoice_8.id, quantity: 1, unit_price: 78000, status: 0)
    @invoice_iem_8 = create(:invoice_item, item_id: @item_8.id, invoice_id: @invoice_9.id, quantity: 4, unit_price: 5500, status: 0)
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :status }
  end

  describe 'Relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many :bulk_discounts }
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["disabled", "enabled"])
    end
  end

  describe '#instance methods' do 
    it "#top_five_customers" do 
      customers = [@customer_1, @customer_2]

      expect(@merchant_1.top_five_cust).to eq(customers)
    end

    it "#not_shipped_invoices" do
      expect(@merchant_1.not_shipped_invoices).to eq([@invoice_1, @invoice_2])
    end

    describe '#enabled?' do
      it 'returns true or false depending on the status' do
        merch_1 = create(:merchant, name: "Amazon", status: 0)

        expect(merch_1.enabled?).to eq(false)

        merch_2 = create(:merchant, name: "Petco", status: 1) 

        expect(merch_2.enabled?).to eq(true)
      end
    end

    describe "#revenue_to_dollars" do
      it 'returns an integer with the pennies converted to dollars' do 
        expect(Merchant.top_five_merchants[0].revenue_to_dollars).to eq(1560)
      end
    end
    
    describe '#top_revenue_day' do
      it 'returns the date for the merchants highest revenue' do
        expect(@merchant_1.top_revenue_day).to eq("2024-02-22 00:47:11.096539 UTC")
        expect(@merchant_2.top_revenue_day).to eq("2024-02-21 00:47:11.096539 UTC")
        expect(@merchant_3.top_revenue_day).to eq("2024-02-20 00:47:11.096539 UTC")
        expect(@merchant_5.top_revenue_day).to eq("2024-02-21 00:47:11.096539 UTC")
        expect(@merchant_6.top_revenue_day).to eq("2024-02-21 00:47:11.096539 UTC")
      end
    end
  end

  describe '.class methods' do
    describe ".top_five_merchants" do
      it "returns an array of the 5 merchants with the highest revenue" do
        expect(Merchant.top_five_merchants).to eq([@merchant_2, @merchant_3, @merchant_5, @merchant_1, @merchant_6])
      end
    
      describe "#eligible_discount" do
        it "returns the biggest discount that the quantity qualifies for" do
          expect(@merchant_1.eligible_discount(15)).to eq(30)
          expect(@merchant_1.eligible_discount(10)).to eq(20)
        end
        
        it "returns 0 when no discount is applicable" do
          expect(@merchant_1.eligible_discount(5)).to eq(0)
        end
      end

      describe "#b_discount" do
        it "returns the full object of the biggest discount that the quantity qualifies for" do
          expect(@merchant_1.b_discount(15)).to eq(@discount_m1_B)
          expect(@merchant_1.b_discount(10)).to eq(@discount_m1_A)
        end
      end
    end
  end
end
