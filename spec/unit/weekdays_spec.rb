require 'spec_helper'
require './lib/weekdays'

describe Weekdays do

  context "a weekdays module" do

    let(:instance) { (Class.new { include Weekdays }).new }

    it "should identify the correct number of weekdays between two dates in the same week" do
      [
        # Each day of the week
        ['03-03-2016 13:15', '03-03-2016 13:16', 0],
        ['03-03-2016 13:15', '04-03-2016 13:14', 0], # 23 hours and 59 minutes
        ['03-03-2016 13:15', '04-03-2016 13:15', 1], # 24 hours
        ['03-03-2016 13:15', '05-03-2016 13:15', 1], # 5/Mar and 6/Mar are weekend
        ['03-03-2016 13:15', '06-03-2016 13:15', 1],
        ['03-03-2016 13:15', '07-03-2016 13:15', 2],
        ['03-03-2016 13:15', '08-03-2016 13:15', 3],
        ['03-03-2016 13:15', '09-03-2016 13:15', 4],
        ['03-03-2016 13:15', '10-03-2016 13:15', 5],
        ['03-03-2016 13:15', '11-03-2016 13:14', 5],
        # Some special cases
        ['03-03-2016 13:15', '03-03-2016 13:14', 0],      # Same day, different time
        ['10-03-2016 13:15', '03-03-2016 13:14', 5],      # Reverse order
        ['31-12-2014 23:59', '01-01-2015 00:00', 0],      # New year
        ['05-03-2016 13:15', '06-03-2016 13:15', 0],      # Inside a weekend
        ['27-03-2016 00:00', '27-03-2016 23:59', 0],      # Change of time
        ['30-10-2016 00:00', '30-10-2016 23:59', 0],
        ['27-03-2016 00:00', '28-03-2016 00:00', 1],      # Change of time
        ['30-10-2016 00:00', '31-10-2016 00:00', 1],      # Change of time
        ['27-03-2016 01:00', '27-03-2016 23:59', 0],
        ['27-03-2016 01:00', '28-03-2016 01:00', 1],      # Between days and change of time
        ['30-10-2016 02:00', '31-10-2016 00:00', 0],
        ['30-10-2016 02:00', '31-10-2016 02:00', 1],
        ['28-10-2016 13:15', '31-10-2016 13:16', 1],
        ['25-03-2016 13:15', '28-03-2016 13:16', 1]

      ].each do |date_a, date_b, weekdays|
        value = instance.weekdays_between(DateTime.parse(date_a), DateTime.parse(date_b))
        value.should eq(weekdays), "#{date_a} and #{date_b} should have #{weekdays} weekdays in between, but it was #{value}"
      end
    end

    it "should identify the correct number of weekdays between two dates in different weeks" do
      [
        ['03-03-2016 13:15', '11-03-2016 13:15', 6],      # 1 day after the week
        ['03-03-2016 13:15', '03-04-2016 13:15', 21],     # some weeks between
        ['02-02-2016 09:37', '31-08-2016 09:36', 150],    # 1 minute before deadline
        ['02-02-2016 09:37', '31-08-2016 09:37', 151],    # Exact deadline
        ['02-02-2016 09:37', '31-08-2016 17:32', 151],    # A little bit after deadline
        ['03-03-2014 13:15', '03-03-2015 13:15', 261],    # Normal year
        ['03-03-2015 13:15', '03-03-2016 13:15', 262],    # Leap year
        ['01-10-1974 00:15', '15-08-2013 23:15', 10142],  # Really far dates
      ].each do |date_a, date_b, weekdays|
        value = instance.weekdays_between(DateTime.parse(date_a), DateTime.parse(date_b))
        value.should eq(weekdays), "#{date_a} and #{date_b} should have #{weekdays} weekdays in between, but it was #{value}"
      end
    end

    it "should operate correctly with DateTime days" do
        date_a = DateTime.parse('03-03-2014 13:15')
        [[1, :day, 1], [7, :day, 5], [1, :week, 5], [6, :week, 30], [42, :day, 30]].each do |val, type, expected_val|
          instance.weekdays_between(date_a, date_a + val.send(type)).should eq(expected_val)
        end
    end
  end
end
