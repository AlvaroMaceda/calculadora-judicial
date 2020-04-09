class Municipality < ApplicationRecord
  belongs_to :autonomous_community
  has_many :holidays, as: :holidayable

  
end
