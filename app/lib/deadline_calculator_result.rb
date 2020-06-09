
class DeadlineCalculatorResult

    attr_reader :deadline, :holidays_affected, :missing_holidays_for

    def initialize(deadline:,holidays_affected:, missing_holidays_for: [])
        @deadline = deadline
        @holidays_affected = holidays_affected.clone.freeze
        @missing_holidays_for = missing_holidays_for.clone.freeze
    end

    def ==(other)
        return compare_contents(other) if other.instance_of?(self.class)
        return compare_date(other) if other.instance_of?(Date)
        return false
    end
    alias_method :eql?, :==

private

    def compare_contents(other)
        @deadline == other.deadline && 
        @holidays_affected == other.holidays_affected &&
        @missing_holidays_for == other.missing_holidays_for
    end

    def compare_date(date)
        @deadline == date
    end

end