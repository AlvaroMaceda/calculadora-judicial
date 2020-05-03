class Municipality < ApplicationRecord
    belongs_to :autonomous_community
    has_many :municipalities

    has_many :holidays, as: :holidayable

    # We will prefix code with ISO 3166-1 country codes if this app becomes multicountry one day 
    validates :code, 
        presence: true, 
        length: {minimum: 7, maximum: 7}, 
        allow_blank: false,
        uniqueness: true

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
