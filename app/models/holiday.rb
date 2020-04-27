class Holiday < ApplicationRecord
    belongs_to :holidayable, polymorphic: true

    validates :date,
    presence: true,
    uniqueness: {
        scope: :holidayable,
        message: ->(object, data) do
            "(#{data[:model]}): #{data[:value]} already exist!"
        end
    }
    validate :not_sunday
  
    scope :between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}
    
    def not_sunday
        if date && date.sunday?
            errors.add(:date, 'cannot be sunday')
        end
    end

end
