
class DeadlineCalculatorResult

    attr_reader :deadline, :holidays_affected

    def initialize(deadline:,holidays_affected:)
        @deadline = deadline
        @holidays_affected = holidays_affected.clone.freeze
    end

    def ==(other)
        return compare_result(other) if other.instance_of?(self.class)
        return compare_date(other) if other.instance_of?(Date)
        return false
    end
    alias_method :eql?, :==

private

    def compare_result(result)
        @deadline == result.deadline && @holidays_affected == result.holidays_affected
    end

    def compare_date(date)
        @deadline == date
    end

end