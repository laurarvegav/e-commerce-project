require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe 'initialize' do
    it "initializes holiday instance with attributes" do
      holiday = Holiday.new({"date"=> "2024-03-03", "name"=> "President's Day"})

      expect(holiday).to be_a(Holiday)
      expect(holiday.name).to eq("President's Day")
      expect(holiday.date).to eq("2024-03-03")
    end
  end
end