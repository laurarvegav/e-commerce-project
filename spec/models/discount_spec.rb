require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :percent_discount}
    it { should validate_presence_of :quantity_threshold }
  end

  describe 'relationships' do
    it {should belong_to :merchant}
    it { should have_many :items }
  end

  describe 'instance methods' do
  end
end