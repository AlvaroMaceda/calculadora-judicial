class AutonomousCommunity < ApplicationRecord
  belongs_to :country
  has_many :holidays, as: :holidayable

  validates :name, presence: true
end
