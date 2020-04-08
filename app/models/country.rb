class Country < ApplicationRecord
    has_many :holidays as :holidable
end
