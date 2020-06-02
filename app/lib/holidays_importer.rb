class HolidaysImporter

    include CsvBasicImporter

    def initialize()
        @territories = ItemsCache::create { |code| find_territory(code)}
    end

    private
    
    def process_row(row)
        create_holiday row
    end

    def expected_headers
        ['code', 'date']
    end

    def create_holiday(row)
        begin
            territory = @territories[row['code']]
            date = parse_date(row['date'])

            Holiday.create!(holidayable: territory, date: date)

        rescue ActiveRecord::RecordInvalid => e
            raise_import_error 'Error creating holiday', row, e

        rescue InvalidDate => e
            raise_import_error 'Invalid date, expected dd/mm/YYYY', row, e

        rescue TerritoryNotFound => e
            raise_import_error 'Territory not found',row,e

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

    def find_territory(code)
        return nil if code == ''

        territory = Territory.find_by(code: code)
        raise TerritoryNotFound.new("Territory code: '#{code}'") unless territory
        return territory
    end

    class TerritoryNotFound < RuntimeError
    end

    class InvalidDate < RuntimeError
    end

end