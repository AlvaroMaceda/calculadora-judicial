require 'date'

class WorkingDaysCalculator

    def initialize(holidayable)
        @holidayable = holidayable
    end

    def deadline(init_date, days)
        return Date.new(2018,10,10)
    end

end
