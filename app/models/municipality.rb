class Municipality < ApplicationRecord
    belongs_to :autonomous_community
    has_many :municipalities

    has_many :holidays, as: :holidayable

    before_save :calculate_searchable_name

    # We will prefix code with ISO 3166-1 country codes if this app becomes multicountry one day 
    validates :code, 
        presence: true, 
        length: {minimum: 7, maximum: 7}, 
        allow_blank: false,
        uniqueness: true

    validates :name, presence: true

    scope :similar_to, ->(name) {
      searchable_name = Municipality.searchable_string(name)   
      where(
        "searchable_name LIKE ?", "%#{searchable_name}%"
    )
    }

    def holidays_between(start_date, end_date)
      self_holidays = holidays.between(start_date, end_date).to_a
      autonomous_community_holidays = autonomous_community.holidays_between(start_date, end_date).to_a

      my_holidays_unordered = self_holidays + autonomous_community_holidays

      return my_holidays_unordered.sort_by { |holiday| holiday[:date] }
    end

    private

    def calculate_searchable_name
      self.searchable_name = Municipality.searchable_string(name)
    end

    class << self
      def searchable_string(str)
        remove_special_chars(str).delete(' ').downcase
      end

      private 

      def remove_special_chars(str)
        transliterated = I18n.transliterate(str)
        chars_to_remove = "-/'"
        transliterated.tr(chars_to_remove,'')
      end
    end

end
