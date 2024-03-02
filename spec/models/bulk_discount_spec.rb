require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
 describe 'validations' do
  it { should validate_presence_of :percentage_discount }
  it { should validate_presence_of :quantity_treshold }
  it { should validate_numericality_of :percentage_discount }
  it { should validate_numericality_of :quantity_treshold }
 end

 describe 'relationships' do
  it { should belong_to :merchant }
  #it { should have_many : }
 end

 describe 'instance methods' do
 end
end