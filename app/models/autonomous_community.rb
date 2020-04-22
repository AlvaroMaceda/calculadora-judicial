class AutonomousCommunity < ApplicationRecord
  belongs_to :country
  has_many :municipalities

  has_many :holidays, as: :holidayable

  validates :code, 
      presence: true, 
      length: {minimum: 2, maximum: 2}, 
      allow_blank: false,
      uniqueness: {
        scope: :country,
        message: ->(object, data) do
          "(#{data[:model]}): #{data[:value]} is taken already for that Country!"
        end
      }

  validates :name, presence: true, allow_blank: false
end
