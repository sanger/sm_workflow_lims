require 'spec_helper'
require './lib/weekdays'

describe Weekdays do

  context "a weekdays module" do

    let(:instance) { (Class.new { include Weekdays }).new }

    it "should identify the correct number of weekdays between two dates in the same week" do
      [
        ['03-03-2016 13:15', '03-03-2016 13:15', 0],
        ['03-03-2016 13:15', '04-03-2016 13:15', 1],
        ['03-03-2016 13:15', '05-03-2016 13:15', 2],
        ['03-03-2016 13:15', '06-03-2016 13:15', 2],
        ['03-03-2016 13:15', '07-03-2016 13:15', 2],
        ['03-03-2016 13:15', '08-03-2016 13:15', 3],
        ['03-03-2016 13:15', '09-03-2016 13:15', 4],
        ['03-03-2016 13:15', '10-03-2016 13:15', 5]
      ].each do |date_a, date_b, weekdays|
        value = instance.weekdays_between(DateTime.parse(date_a), DateTime.parse(date_b))
        value.should eq(weekdays), "#{date_a} and #{date_b} should have #{weekdays} working days in between, but it was #{value}"
      end
    end

    it "should identify the correct number of weekdays between dispersed dates" do
      [
        ['03-03-2014 13:15', '03-03-2015 13:15', 261],    # Normal year
        ['03-03-2015 13:15', '03-03-2016 13:15', 262],    # Leap year
        ['01-10-1974 00:15', '15-08-2013 23:15', 10142],  # Far dates
        ['03-03-2016 13:15', '03-03-2016 13:14', 0],      # Same day, different time
        ['10-03-2016 13:15', '03-03-2016 13:14', 5],      # Reverse order
        ['31-12-2014 23:59', '01-01-2015 00:00', 1],      # New year
        ['05-03-2016 13:15', '06-03-2016 13:15', 0],      # Inside a weekend
        ['27-03-2016 00:00', '27-03-2016 23:59', 0],      # Change of time
        ['30-10-2016 00:00', '30-10-2016 23:59', 0],
        ['27-03-2016 01:00', '28-03-2016 01:00', 0],
        ['30-10-2016 02:00', '31-10-2016 00:00', 0],
        ['28-10-2016 13:15', '31-10-2016 13:15', 1],
        ['25-03-2016 13:15', '28-03-2016 13:15', 1]
      ].each do |date_a, date_b, weekdays|
        value = instance.weekdays_between(DateTime.parse(date_a), DateTime.parse(date_b))
        value.should eq(weekdays), "#{date_a} and #{date_b} should have #{weekdays} working days in between, but it was #{value}"
      end
    end

    it "should count the correct number of weekdays if count last day is selected" do
      [
        ['03-03-2016 13:15', '03-03-2016 13:15', 1],
        ['03-03-2016 13:15', '04-03-2016 13:15', 2],
        ['03-03-2016 13:15', '05-03-2016 13:15', 2],
        ['03-03-2016 13:15', '06-03-2016 13:15', 2],
        ['03-03-2016 13:15', '07-03-2016 13:15', 3],
        ['03-03-2016 13:15', '08-03-2016 13:15', 4],
        ['03-03-2016 13:15', '09-03-2016 13:15', 5],
        ['03-03-2016 13:15', '10-03-2016 13:15', 6],
        ['01-10-1974 00:15', '15-08-2013 23:15', 10143],  # Far dates, and counting last day of range
        ['28-10-2016 13:15', '31-10-2016 13:15', 2],      # Change of time
        ['25-03-2016 13:15', '28-03-2016 13:15', 2],
        ['27-03-2016 00:00', '27-03-2016 23:59', 0],      # Change of time and Sunday
        ['30-10-2016 00:00', '30-10-2016 23:59', 0],      # Change of time and Sunday
      ].each do |date_a, date_b, weekdays|
        value = instance.weekdays_between(DateTime.parse(date_a), DateTime.parse(date_b), {:count_last_day => true})
        value.should eq(weekdays), "#{date_a} and #{date_b} should have #{weekdays} working days in between, but it was #{value}"
      end
    end

  end

end
