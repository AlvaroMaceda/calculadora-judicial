class Municipality < ApplicationRecord
    belongs_to :autonomous_community
    has_many :municipalities

    has_many :holidays, as: :holidayable

    validates :code, 
        presence: true, 
        length: {minimum: 5, maximum: 5}, 
        allow_blank: false,
        uniqueness: {
            scope: :autonomous_community,
            message: ->(object, data) do
              "(#{data[:model]}): #{data[:value]} is taken already for that autonomous community!"
            end
        }

    validates :name, presence: true

    NAME_FIELD_WITHOUT_SPACES = "LOWER(REPLACE(`name`, ' ', ''))"

    scope :similar_to, ->(name) {
      where(
          "#{NAME_FIELD_WITHOUT_SPACES} LIKE ?", "%#{name}%"
      )
    }

    def holidays_between(start_date, end_date)
      self_holidays = holidays.between(start_date, end_date).to_a
      autonomous_community_holidays = autonomous_community.holidays_between(start_date, end_date).to_a

      my_holidays_unordered = self_holidays + autonomous_community_holidays

      return my_holidays_unordered.sort_by { |holiday| holiday[:date] }

    end

end
