require 'date'

class DeadlineCalculator

    WORKING_DAYS_IN_A_WEEK = 5
    DAYS_IN_A_WEEK = 7
    DAYS_IN_A_WEEKEND = 2

    def initialize(holidayable)
        @holidayable = holidayable
    end

    def deadline(notification_date, days)
    
        start_date = next_working_day(notification_date)

        whole_weeks = days / WORKING_DAYS_IN_A_WEEK
        single_days = days % WORKING_DAYS_IN_A_WEEK - 1 # notification day does not count
        
        days_to_add =  (whole_weeks * DAYS_IN_A_WEEK)
        days_to_add += single_days
        days_to_add += DAYS_IN_A_WEEKEND if extra_weekend?(start_date,single_days)

        end_date_without_holidays = start_date+days_to_add

        return end_date_without_holidays + applicable_holidays(notification_date, end_date_without_holidays)
    end

    private

    def applicable_holidays(notification_date, end_date)
        holidays = @holidayable.holidays_between(notification_date+1, end_date)
        puts @holidayable.name
        puts @holidayable.holidays.to_a.map { |holiday| holiday.date}
        puts '----------'
        puts notification_date+1
        puts end_date
        puts 'Computed holidays:'
        puts holidays
        holidays.count
    end

    def next_working_day(date)
        return date+2 if date.saturday?
        return date+3 if date.friday? 
        date+1
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
