class Country < ApplicationRecord
    has_many :holidays, as: :holidayable
end
