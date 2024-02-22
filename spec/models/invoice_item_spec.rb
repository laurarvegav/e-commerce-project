require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "Relationships" do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end

  describe "Validations" do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :status}
  end

  describe "Enums" do
    xit "enum tests" do
    end
  end
end