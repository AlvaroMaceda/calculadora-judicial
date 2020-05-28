
class CountryHolidaysImporter

    include CsvBasicImporter

    private

    def process_row(row)
        # create_municipality row
    end

    def expected_headers
        ['type', 'code', 'date']
    end

end