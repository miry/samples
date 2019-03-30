# frozen_string_literal: true

## ref: https://www.codewars.com/kata/after-midnight/train/ruby
# Write a function that takes a negative or positive integer, which represents the number of minutes before (-) or after (+) Sunday midnight, and returns the current day of the week and the current time in 24hr format ('hh:mm') as a string. 

WEEKDAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
def day_and_time(diff)
  hour = 60
  day  = 24 * hour
  week = 7 * day
  
  current = (week + diff) % week

  week_day_indx, day_minutes = current.divmod(day)
  week_day = WEEKDAYS[week_day_indx-1]

  hours, minutes = day_minutes.divmod(hour)
  "%s %.2d:%.2d" % [week_day, hours, minutes]
end
