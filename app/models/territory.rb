
class Territory < ApplicationRecord
    belongs_to :parent, optional: true, class_name: "Territory"
    has_many :territories, class_name: "Territory", foreign_key: "parent"

    include Holidayable

    validates :code, 
        presence: true, 
        allow_blank: false,
        uniqueness: true

    validates :name, 
        presence: true, 
        allow_blank: false

    def holidays_between(start_date, end_date)
        
        if parent
            parent_holidays = parent.holidays_between(start_date, end_date).to_a 
        else
            parent_holidays = []
        end

        self_holidays = holidays.between(start_date, end_date).to_a

        my_holidays_unordered = self_holidays + parent_holidays
    
        return my_holidays_unordered.sort_by { |holiday| holiday[:date] }
    end
end
