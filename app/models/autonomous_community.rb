class AutonomousCommunity < ApplicationRecord
  belongs_to :Country
  has_many :holidays, as: :holidayable
end
