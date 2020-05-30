
class Territory < ApplicationRecord
    belongs_to :parent, optional: true, class_name: "Territory"
    has_many :territories, class_name: "Territory", foreign_key: "parent"

    enum kind: {
        country: 'country', 
        autonomous_community: 'autonomous_community', 
        island: 'island', 
        region: 'region', 
        municipality: 'municipality' 
    }, _prefix: :kind

    include Holidayable

    before_save :calculate_searchable_name

    validates :code, 
        presence: true, 
        allow_blank: false,
        uniqueness: true

    validates :name, 
        presence: true, 
        allow_blank: false

    validates :kind, 
        presence: true, 
        allow_blank: false

  
    scope :similar_to, ->(name) {
        searchable_name = Territory.searchable_string(name)   
        where(
            "searchable_name LIKE ?", "%#{searchable_name}%"
        )
    }

    def holidays_between(start_date, end_date)
        
        if parent
            parent_holidays = parent.holidays_between(start_date, end_date).to_a 
        else
            parent_holidays = []
        end

        self_holidays = holidays.between(start_date, end_date).to_a

        my_holidays_unordered = self_holidays + parent_holidays
    
        return my_holidays_unordered.sort_by { |holiday| holiday[:date] }
    end

    private

    def calculate_searchable_name
        self.searchable_name = Territory.searchable_string(name)
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
