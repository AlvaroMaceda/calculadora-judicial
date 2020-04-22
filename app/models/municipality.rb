class Municipality < ApplicationRecord
  self.primary_key = 'code'

  belongs_to :autonomous_community, primary_key: 'code'

  has_many :holidays, as: :holidayable

  validates :code, presence: true, uniqueness: true, length: {minimum: 5, maximum: 5}, allow_blank: false
  validates :name, presence: true

  NAME_FIELD_WITHOUT_SPACES = "LOWER(REPLACE(`name`, ' ', ''))"

  scope :similar_to, ->(name) {
    where(
      "#{NAME_FIELD_WITHOUT_SPACES} LIKE ?", "%#{name}%"
    )
  }
end
