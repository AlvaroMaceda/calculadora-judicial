class AutonomousCommunity < ApplicationRecord
  belongs_to :country
  has_many :holidays, as: :holidayable
end
