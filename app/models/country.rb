class Country < ApplicationRecord
    has_many :holidays, as: :holidayable

    validates :name, presence: true
end
