require 'date'

class DeadlineCalculator

    WORKING_DAYS_IN_A_WEEK = 5
    DAYS_IN_A_WEEK = 7
    DAYS_IN_A_WEEKEND = 2

    def initialize(holidayable)
        @holidayable = holidayable
    end

    def deadline_old(notification_date, days)
    
        start_date = next_working_day(notification_date)

        whole_weeks = days / WORKING_DAYS_IN_A_WEEK
        single_days = days % WORKING_DAYS_IN_A_WEEK - 1 # notification day does not count
        
        days_to_add =  (whole_weeks * DAYS_IN_A_WEEK)
        days_to_add += single_days
        days_to_add += DAYS_IN_A_WEEKEND if extra_weekend?(start_date,single_days)

        end_date_without_holidays = start_date+days_to_add

        return end_date_without_holidays + applicable_holidays(notification_date, end_date_without_holidays)
    end

    def deadline(notification_date, days)
    
        start_date = adjust_if_friday_or_saturday(notification_date)

        whole_weeks = days / WORKING_DAYS_IN_A_WEEK
        single_days = days % WORKING_DAYS_IN_A_WEEK
        
        puts
        puts "days: #{days}"
        puts "notification_date: #{notification_date}"         
        puts "start_date: #{start_date}" 
        puts "whole_weeks: #{whole_weeks}"
        puts "single_days: #{single_days}" 
        puts
        
        days_to_add =  (whole_weeks * DAYS_IN_A_WEEK)
        days_to_add += single_days
        days_to_add += DAYS_IN_A_WEEKEND if extra_weekend?(start_date,single_days)

        end_date_without_holidays = start_date+days_to_add

        return apply_holidays(start_date, end_date_without_holidays)
        # return end_date_without_holidays + applicable_holidays(notification_date, end_date_without_holidays)
    end

    private

    def applicable_holidays(notification_date, end_date)
        holidays = @holidayable.holidays_between(notification_date+1, end_date)
        puts '-------------------------'
        puts holidays.map { |holiday| "#{holiday.holidayable.name} #{holiday.date}" }
        puts '-------------------------'
        holidays.count
    end
    
    def adjust_if_friday_or_saturday(date)
        # We count from sunday if notified friday or saturday
        return date+2 if date.friday?
        return date+1 if date.saturday? 
        date
    end

    def num_holidays_inside_interval(start_date, end_date)
        @holidayable.holidays_between(start_date, end_date).count
    end

    def is_holiday?(date)
        @holidayable.holidays_between(date, date).count > 0
    end

    def is_weekend?(date)
        date.saturday? or date.sunday?
    end

    def non_working?(date)
        is_weekend?(date) or is_holiday?(date)
    end

    def apply_holidays(start_date, end_date)
        num_holidays = num_holidays_inside_interval(start_date, end_date)
        puts
        puts "start_date: #{start_date}"
        puts "end_date without holidays: #{end_date}"
        puts "num_holidays: #{num_holidays}"
        puts
        end_date += num_holidays
        while( non_working?(end_date) )
            end_date +=1
        end
        end_date
    end

    """
    This function is only for <1week terms
    We should add an extra weekend if there is a weekend between the start date and the end date

    Imagine we shift the days 
           Su Mo Tu We Th Fr Sa Su 
    1         Su Mo Tu We Th Fr Sa
    2            Su Mo Tu We Th Fr Sa
    3               Su Mo Tu We Th Fr Sa
    4                  Su Mo Tu We Th Fr Sa

    We will add an extra weekend if the day ends in saturday, sunday or beyond.
    For example:
        - If we start in We and count 2 days we will end in Fr (it's in friday's position on top row):
          no extra weekend
        - If we start in We and count 3 days we will end in Sa: extra weekend
        - If we start in We and count 4 days we will end in Su: extra weekend
        - If we start in Fr and count 1 days we will end in Sa: extra weekend

    day_of_week         shifts_with_extra_weekend
              1	  Mo    none
              2   Tu    4
              3   We    3,4
              4   Th    2,3,4
              5   Fr    1,2,3,4
    
    So we must add extra weekend when shift > (5-dow)
            
    We can have only 0 to 4 single days shifts: 5 days shifts are counted as whole week shifts
    We never start in saturday on sunday (that's handled by next_working_day)
    """
    def extra_weekend?(date, shift)
        shift > ( 5 - date.wday )
    end

end
