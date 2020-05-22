class Country < ApplicationRecord
    has_many :autonomous_communities
    include Holidayable

    validates :code, 
        presence: true, 
        length: {minimum: 2, maximum: 2}, 
        allow_blank: false,
        uniqueness: true

    validates :name, presence: true

    # Start and end dates are included
    def holidays_between(start_date, end_date)
        holidays.between(start_date, end_date).to_a
    end
end
