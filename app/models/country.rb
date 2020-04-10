class Country < ApplicationRecord
    has_many :holidays, as: :holidayable
    # has_many :autonomous_communities

    validates :name, presence: true
end
