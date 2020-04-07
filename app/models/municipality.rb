class Municipality < ApplicationRecord
    has_many :holidays, as: :holidayable
end
