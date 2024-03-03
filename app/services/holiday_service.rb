class HolidayService
  def upcoming_holidays
    holidays = get_url("https://date.nager.at/api/v3/publicholidays/2024/US")
    filtered_holidays = parse_and_filter_holidays(holidays)
    sorted_holidays = sort_holidays_by_date(filtered_holidays).take(3)
  end

  def get_url(url)
    response = HTTParty.get(url)
  end

  def sort_holidays_by_date(holidays)
    upc_holidays = holidays.find_all do |holiday| 
      Date.parse(holiday["date"]) >= Date.today
    end
    sorted_holidays = upc_holidays.sort_by { |holiday| Date.parse(holiday["date"]) }
  end

  def parse_and_filter_holidays(holidays_data)
    holidays_data.uniq { |holiday| [holiday["date"], holiday["name"]] }
  end
end