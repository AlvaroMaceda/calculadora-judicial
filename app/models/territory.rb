
class Territory < ApplicationRecord
    after_initialize :set_defaults, unless: :persisted?

    belongs_to :parent, optional: true, class_name: "Territory"
    has_many :territories, class_name: "Territory", foreign_key: "parent", dependent: :destroy 

    enum kind: {
        country: 'country', 
        autonomous_community: 'autonomous_community', 
        island: 'island', 
        region: 'region', 
        municipality: 'municipality',
        local_entity: 'local_entity'
    }, _suffix: :kind

    enum court: {
        have: 'S',
        no: 'N'
    }, _suffix: :court

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

    validates :population, 
        :numericality => { :greater_than_or_equal_to => 0 },
        presence: true

    validates :court, 
        presence: true, 
        allow_blank: false  

    scope :similar_to, ->(name) {
        searchable_name = Territory.searchable_string(name)   
        where(
            "searchable_name LIKE ?", "%#{searchable_name}%"
        )
    }

    scope :settlements, ->() {
        where(
            kind: [:municipality, :local_entity]
        )
    }

    scope :by_relevance, -> { order(court: :desc, population: :desc) }

    def holidays_between(start_date, end_date)
        
        parent_holidays = parent ? parent.holidays_between(start_date, end_date).to_a : []

        if self.local_entity_kind?
            parent_holidays = remove_holidays_of_municipalities(parent_holidays)
        end

        self_holidays = self_holidays_between(start_date, end_date)

        my_holidays_unordered = self_holidays + parent_holidays
    
        return my_holidays_unordered.sort_by { |holiday| holiday[:date] }
    end

    def holidays_missing_for(year)
        self_missing_holidays =  have_self_holidays_for?(year) ? [] : [self]
        parent_missing_holidays = parent ? parent.holidays_missing_for(year) : []
        return self_missing_holidays+parent_missing_holidays 
    end
    
    private
    
    def have_self_holidays_for?(year)
        # We are assuming that it MUST have at least one holiday per year. 
        # No holidays for a year means that the data is still not recorder into the DB
        self_holidays_between(Date.new(year.to_i,1,1), Date.new(year.to_i,12,31)).count > 0
    end

    def self_holidays_between(start_date, end_date)
        holidays.between(start_date, end_date).to_a
    end

    def set_defaults
        self.population ||= 0
        self.court ||= :no
    end

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

    def remove_holidays_of_municipalities(holidays)
        holidays.select { |h| !h.holidayable.municipality_kind? }
    end

end
