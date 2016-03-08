module Weekdays
  def ellapsed_weekdays_before(day_of_week, number_of_days, options = {})
    count_last_day = 0
    count_last_day = 1 if options[:count_last_day]==true

    ellapsed_weekdays=0
    (count_last_day + number_of_days).times do |days|
      actual_day_of_week =  ((day_of_week - days - 1 + count_last_day) % 7)
      if (actual_day_of_week != 2) &&  (actual_day_of_week != 3)
        ellapsed_weekdays +=1
      end
    end
    ellapsed_weekdays
  end


  def weekdays_between(date_a, date_b, options = {})
    # Dates sorted to be correctly processed
    unix_date_lower, unix_date_greater = [date_a, date_b].map(&:to_i).sort
    # Number of days if there is more than 1 day in between
    days = ((unix_date_greater - unix_date_lower) / (3600 * 24)).floor
    # Any pass through 00:00 is considered a new day in between
    days = 1 if days == 0 && date_a.day != date_b.day
    # Complete weeks
    weeks = (days / 7).floor
    # Remainder days from the week counting
    rest_of_days = (days % 7)
    # Day of the week for the greater date of the range, from UNIX epoch
    day_of_week = (unix_date_greater / (3600 * 24)) % 7


    # Every week has 5 working days, plus the number of weekdays from the remainder
    # day of the week
    (weeks * 5) + ellapsed_weekdays_before(day_of_week, rest_of_days, options)
  end
  private :ellapsed_weekdays_before

  #def _weekdays_between(date_a, date_b)
    #_weekdays_between(date_a, date_b, options = { :count_last_day => true })
  #  weekdays_between(date_a, date_b)
  #end
  public :weekdays_between
end
