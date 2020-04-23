require 'date'

class DeadlineCalculator

    WORKING_DAYS_IN_A_WEEK = 5
    DAYS_IN_A_WEEK = 7
    DAYS_IN_A_WEEKEND = 2

    def initialize(holidayable)
        @holidayable = holidayable
    end

    def from_date(date, days)
    
        start_date = next_working_day(date)

        whole_weeks = days / WORKING_DAYS_IN_A_WEEK
        single_days = days % WORKING_DAYS_IN_A_WEEK
        
        days_to_add =  (whole_weeks * DAYS_IN_A_WEEK)
        days_to_add += single_days
        days_to_add += DAYS_IN_A_WEEKEND if extra_weekend?(start_date,single_days)

        return date+days_to_add
    end

    private

    def next_working_day(date)
        return date+2 if date.saturday?
        return date+1 if date.sunday? 
        date
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
        - If we start in We and count 2 days we will end in Fr, no extra weekend
        - If we start in We and count 3 days we will end in Sa, extra weekend
        - If we start in We and count 4 days we will end in Su, extra weekend
        - If we start in Fr and count 1 days we will end in Sa, extra weekend

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
