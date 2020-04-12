class Country < ApplicationRecord
    has_many :autonomous_communities
    
    has_many :holidays, as: :holidayable

    validates :name, presence: true
end
