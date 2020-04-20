class Country < ApplicationRecord
    has_many :autonomous_communities
    include Holidayable

    validates :name, presence: true
end
