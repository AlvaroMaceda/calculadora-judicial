class AutonomousCommunity < ApplicationRecord
  self.primary_key = 'code'

  belongs_to :country
  has_many :municipalities

  has_many :holidays, as: :holidayable

  validates :code, presence: true, uniqueness: true, length: {minimum: 2, maximum: 2}, allow_blank: false
  validates :name,
    presence: true,
    uniqueness: {
      scope: :country,
      message: ->(object, data) do
        "(#{data[:model]}): #{data[:value]} is taken already!"
      end
    }
end
