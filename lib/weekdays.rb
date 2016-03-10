module Weekdays
  public
  def weekdays_between(date_a, date_b, options = {})
    lower_date, greater_date = [date_a, date_b].sort

    num_weeks = ((greater_date - lower_date).days / 1.week).floor
    pivot_date = lower_date + num_weeks.weeks

    (num_weeks * 5) + num_weekdays_between(pivot_date, greater_date)
  end

  private
  def num_weekdays_between(lower_date, greater_date)
    weekdays = 0
    pivot_date = lower_date + 1.day
    while (pivot_date <= greater_date) do
      weekdays +=1 unless pivot_date.saturday? or pivot_date.sunday?
      pivot_date += 1.day
    end
    weekdays
  end

end
