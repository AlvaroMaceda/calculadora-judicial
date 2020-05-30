
class CountryHolidaysImporter

    include CsvBasicImporter

    def initialize()
        @countries = ItemsCache::create { |code| find_country(code)}
    end

    private
    
    def process_row(row)
        create_country_holiday row
    end

    def expected_headers
        ['code', 'date']
    end
    
    def create_country_holiday(row)
        begin
            country = @countries[row['code']]
            date = parse_date(row['date'])

            Holiday.create!(holidayable: country, date: date)

        rescue ActiveRecord::RecordInvalid => e
            raise_import_error 'Error creating country\'s holiday', row, e

        rescue InvalidDate => e
            raise_import_error 'Invalid date, expected dd/mm/YYYY', row, e

        rescue CountryNotFound => e
            raise_import_error 'Country not found',row,e
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

    class InvalidDate < RuntimeError
    end

    class CountryNotFound < RuntimeError
    end

end