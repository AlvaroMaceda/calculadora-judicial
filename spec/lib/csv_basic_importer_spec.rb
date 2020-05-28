require 'rails_helper'

describe CsvBasicImporter do

    let(:importer_class) { 
        Class.new do
            include CsvBasicImporter
            def expected_headers
                ['headerA','headerB','headerC']
            end
            def process_row(row)
            end
        end        
    }
    let(:importer) { importer_class.new }

    it 'processes rows' do
        csv_data = <<~HEREDOC
            headerA,headerB,headerC
            dataA1,dataB1,dataC1
            dataA2,dataB2,dataC2
        HEREDOC
        
        expected = [
            {'headerA'=>'dataA1', 'headerB'=>'dataB1', 'headerC'=>'dataC1'},
            {'headerA'=>'dataA2', 'headerB'=>'dataB2', 'headerC'=>'dataC2'},
        ]
        
        csv = StringIO.new(csv_data)
        allow(importer).to receive(:process_row)
        importer.importCSV csv     
        
        expected.each do |row|
            expect(importer).to have_received(:process_row).with(row).ordered
        end
    end

    it 'works with a file name' do
        csv_file = File.join(__dir__,'csv_basic_importer_data','correct_example.csv')        
        expected = [
            {'headerA'=>'dataA1', 'headerB'=>'dataB1', 'headerC'=>'dataC1'},
            {'headerA'=>'dataA2', 'headerB'=>'dataB2', 'headerC'=>'dataC2'},
        ]

        allow(importer).to receive(:process_row)
        importer.importCSV csv_file

        expected.each do |row|
            expect(importer).to have_received(:process_row).with(row).ordered
        end
    end

    it 'additional data is ignored' do
        importer = Class.new do
            include CsvBasicImporter
            def expected_headers
                ['headerA','headerB']
            end
        end.new        

        csv_data = <<~HEREDOC
            headerA,headerB,headerC
            dataA1,dataB1,dataC1
            dataA2,dataB2,dataC2
        HEREDOC
        
        expected = [
            {'headerA'=>'dataA1', 'headerB'=>'dataB1'},
            {'headerA'=>'dataA2', 'headerB'=>'dataB2'},
        ]
        
        csv = StringIO.new(csv_data)
        allow(importer).to receive(:process_row)
        importer.importCSV csv     

        expected.each do |row|
            expect(importer).to have_received(:process_row).with(row).ordered
        end
    end

    it 'works with non-ascii characters' do
        csv_data = <<~HEREDOC
            headerA,headerB,headerC
            "ES","01","IIƆS∀ ʇou sᴉ sᴉɥ┴"
        HEREDOC
        csv = StringIO.new(csv_data)

        expected = {'headerA'=>'ES', 'headerB'=>'01', 'headerC'=>'IIƆS∀ ʇou sᴉ sᴉɥ┴'}

        allow(importer).to receive(:process_row)
        importer.importCSV csv     
        
        expect(importer).to have_received(:process_row).with(expected)
    end

    it 'returns statistics' do               
        csv_data = <<~HEREDOC
            headerA,headerB,headerC
            "ES","01","Autonomous Community 1"
            "ES","02","Autonomous Community 2"
            "FR","01","Autonomous Community 1"
        HEREDOC
        csv = StringIO.new(csv_data)

        result = importer.importCSV csv

        expect(result.lines).to eq(4)
        expect(result.imported).to eq(3)        
    end

    context 'errors' do

        it 'raises an error if process_row is not defined' do
            importer = Class.new do
                include CsvBasicImporter
            end.new

            csv_data = <<~HEREDOC
                headerA,headerB,headerC
                dataA1,dataB1,dataC1
                dataA2,dataB2,dataC2                
            HEREDOC
            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
        end

        it 'returns errors in csv' do
            csv_data = <<~HEREDOC
                headerA,headerB,headerC
                "ES","01","A,Treme ndous,error
                "ES","THIS_IS_AN_ERROR","Autonomous Community 2"
            HEREDOC

            csv = StringIO.new(csv_data)
            
            expect {importer.importCSV csv}.to raise_error(CSV::MalformedCSVError)
        end

        it 'returns error if data doesn\t have required headers' do
            csv_data = <<~HEREDOC
                headerA,headerB         
            HEREDOC
            csv = StringIO.new(csv_data)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::HeadersError)
        end

        it 'imports no records if there is an error' do
            # This class will insert into the database and raise an exception in third row
            importer = Class.new do
                include CsvBasicImporter
                def initialize
                    @counter = 1
                end
                def process_row(row)
                    do_insert
                    raise CsvBasicImporter::ImportError.new('third row reached') if @counter == 3
                    @counter += 1
                end
                def do_insert()
                    insert_record = "INSERT INTO some_data_for_tests VALUES ('#{@counter}')"
                    ActiveRecord::Base.connection.execute(insert_record)
                end
            end.new

            csv_data = <<~HEREDOC
            headerA,headerB,headerC
                dataA1,dataB1,dataC1
                dataA2,dataB2,dataC2
                dataA3,dataB3,dataC3
            HEREDOC
            csv = StringIO.new(csv_data)

            # Some DB do not allow nested transactions, so we create and delete the table here
            create_table = <<~HEREDOC
                CREATE TABLE some_data_for_tests ( 
                    some_data STRING NOT NULL
                );
            HEREDOC
            ActiveRecord::Base.connection.execute(create_table)

            expect {importer.importCSV csv}.to raise_error(CsvBasicImporter::ImportError)
            records = ActiveRecord::Base.connection.execute('SELECT * FROM some_data_for_tests')
            expect(records).to eq([])
            
            drop_table = "DROP TABLE some_data_for_tests;"
            ActiveRecord::Base.connection.execute(drop_table)
        end

        it 'returns error if file does not exist' do
            csv_file = File.join(__dir__,'THIS_FILE_DOES_NOT_EXIST.csv')        

            expect {importer.importCSV csv_file}.to raise_error(CsvBasicImporter::ImportError)
        end

    end

end