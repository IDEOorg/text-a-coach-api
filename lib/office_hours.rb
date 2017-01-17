class OfficeHours

  @@timezone = "America/New_York"

  @@holidays = [
    "2017-01-16",
    "2017-02-20",
    "2017-05-29",
    "2017-07-03",
    "2017-07-04",
    "2017-09-04",
    "2017-11-23",
    "2017-11-24",
    "2017-12-22",
    "2017-12-25",
    "2017-12-29",
    "2018-01-01"
  ]

  @@regular_hours = [
    {
      day: 1, #monday
      start: 9,
      end: 17
    },
    {
      day: 2, #tuesday
      start: 9,
      end: 17
    },
    {
      day: 3, #wednesday
      start: 9,
      end: 17
    },
    {
      day: 4, #thursday
      start: 9,
      end: 17
    },
    {
      day: 5, #friday
      start: 9,
      end: 17
    },
  ]

  def self.is_open(time = nil)
    time = Time.now if time.nil?
    time = time.in_time_zone(@@timezone)
    date = time.strftime("%Y-%m-%d")
    wday = time.wday
    hour = time.hour

    if @@holidays.include?(date)
      return false
    end

    todays_hours = @@regular_hours.find { |h| h[:day] == wday }
    if todays_hours
      if hour > todays_hours[:start] && hour < todays_hours[:end]
        return true
      end
    end

    return false
  end

end
