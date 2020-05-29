
class AutonomousCommunityHolidaysImporter

    include CsvBasicImporter

    def initialize()
        @countries = ItemsCache::create { |code| find_country(code)}
        @acs = ItemsCache::create { |key| find_ac(key)}
    end

    private
    
    def process_row(row)
        create_autonomous_community_holiday row
    end

    def expected_headers
        ['country_code','code', 'date']
    end
    
    def create_autonomous_community_holiday(row)
        begin
            ac = @acs[country_code: row['country_code'], code: row['code']]
            date = parse_date(row['date'])

            Holiday.create!(holidayable: ac, date: date)

        rescue ActiveRecord::RecordInvalid => e
            raise_import_error 'Error creating country\'s holiday', row, e

        rescue InvalidDate => e
            raise_import_error 'Invalid date, expected dd/mm/YYYY', row, e

        rescue CountryNotFound => e
            raise_import_error 'Country not found',row,e

        rescue AutonomousCommunityNotFound => e
            raise_import_error 'Autonomous community not found',row,e

        end
    end

    def raise_import_error(text,row,exception)
        message = <<~HEREDOC
            #{text}: 
            #{row.to_s.chomp}
            #{exception.message}
        HEREDOC
    
        raise CsvBasicImporter::ImportError.new(message)
    end

    def parse_date(date)
        begin
            Date.strptime(date, '%d/%m/%Y')
        rescue ArgumentError => e
            raise InvalidDate.new(e.message)
        end
    end

    def find_country(code)
        country = Country.find_by(code: code)
        raise CountryNotFound.new("Country code: '#{code}'") unless country
        return country
    end

    def find_ac(key)
        country = @countries[key[:country_code]]
        ac = AutonomousCommunity.find_by(code: key[:code])
        raise AutonomousCommunityNotFound.new("Autonomous Community code: '#{key[:code]}'") unless ac
        return ac
    end

    class InvalidDate < RuntimeError
    end

    class CountryNotFound < RuntimeError
    end

    class AutonomousCommunityNotFound < RuntimeError
    end

end