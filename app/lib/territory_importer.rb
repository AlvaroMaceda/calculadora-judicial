
class TerritoryImporter
  
    include CsvBasicImporter

    def initialize()
        @territories = ItemsCache::create { |code| find_territory(code)}
    end
    
private

    def expected_headers
        ['parent_code', 'code', 'kind', 'name']
    end

    def optional_headers
        ['population','court']
    end

    def process_row(row)
        create_territory row
    end

    def create_territory(row)
        begin
            kind = row['kind']
            code = row['code']
            name = row['name']
            parent = @territories[row['parent_code']]
            population = row['population']
            court = row['court']

            Territory.create!(
                kind: kind, 
                code: code, 
                name: name, 
                parent: parent, 
                population: population,
                court: court
            )

        rescue ActiveRecord::RecordInvalid => e
            raise_import_error 'Error creating territory', row, e

        rescue TerritoryNotFound => e
            raise_import_error 'Parent territory not found', row, e

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

    def find_territory(code)
        return nil if code == ''

        territory = Territory.find_by(code: code)
        raise TerritoryNotFound.new("Parent territory code: '#{code}'") unless territory
        return territory
    end

    class TerritoryNotFound < RuntimeError
    end

end