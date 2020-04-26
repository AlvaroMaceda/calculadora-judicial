class Country < ApplicationRecord
    has_many :autonomous_communities
    include Holidayable

    validates :name, presence: true

    # Start and end dates are included
    def holidays_between(start_date, end_date)
        holidays.between(start_date, end_date).to_a
    end
end
