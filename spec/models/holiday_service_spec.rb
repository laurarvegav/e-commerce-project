require 'rails_helper'

RSpec.describe HolidayService, type: :model do
  describe 'instance methods' do
    it "gets URL, populating API records into JSON" do
      url = "https://date.nager.at/api/v3/publicholidays/2024/US"

      parsed_holiday_date = HolidayService.new.get_url(url)

      expect(parsed_holiday_date.first).to be_a(Hash)
      expect(parsed_holiday_date.first["name"]).to be_a(String)
      expect(parsed_holiday_date.first["date"]).to be_a(String)
    end

    it "returns the 3 upcoming holidays" do
      url = "https://date.nager.at/api/v3/publicholidays/2024/US"

      holiday_date = HolidayService.new.upcoming_holidays

      #Returns the 3 upcoming
      expect(holiday_date.length).to eq(3)

      holidays = holiday_date
        .sort_by { |holiday| Date.parse(holiday["date"]) }

      #The first one is the first upcoming from today 03/02/2024
      expect(holidays[0]["name"]).to eq("Good Friday")
      expect(holidays[1]["name"]).to eq("Memorial Day")
      expect(holidays[2]["date"]).to eq("2024-06-19")
    end
  end
end