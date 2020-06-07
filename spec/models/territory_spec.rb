require 'rails_helper'


describe Territory, type: :model do
  
    let(:territory) { create(:territory) }

    it "has a valid factory" do
        expect(territory).to be_valid
    end

    it "is invalid without a name" do
        noname_territory = build(:territory, name: nil)
        expect(noname_territory).not_to be_valid
    end

    it "is invalid without a code" do
        nocode_territory = build(:territory, code: nil)
        expect(nocode_territory).not_to be_valid
    end

    it "has a unique code" do
        repeated_territory = build(:territory, code: territory.code)
        expect(repeated_territory).not_to be_valid 
    end

    it 'is of a kind' do
        territory = create(:territory, kind: :municipality)
        expect(territory).to be_valid
    end

    it 'can\'t have negative population' do
        expect {create(:territory, population: -100)}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "can belong to annother territory" do
        parent_territory = create(:territory)
        child_territory = create(:territory, parent: parent_territory)

        expect(child_territory).to be_valid 
    end

    it "can have multiple child territories" do
        parent_territory = create(:territory)
        child_territory_1 = create(:territory, parent: parent_territory)
        child_territory_2 = create(:territory, parent: parent_territory)

        expected_childs = [
            child_territory_1, child_territory_2
        ]

        expect(parent_territory.territories).to match_array(expected_childs) 
    end

    context 'holidays' do
        
        it 'can have multiple holidays' do
            holiday_1 = create(:holiday, holidayable: territory)
            holiday_2 = create(:holiday, holidayable: territory)
            
            expected_holidays = [holiday_1, holiday_2]

            expect(territory.holidays).to match_array(expected_holidays) 
        end

        context 'returns its holidays between two dates in order' do
    
            # Don't know how to resolve this with let
            before(:each) do
                @grandparent = create(:territory)
                @parent = create(:territory, parent: @grandparent)
                @territory = create(:territory, parent: @parent)
                @local_entity = create(:territory, parent: @territory, kind: :local_entity)

                @grandparent_holiday = create(:holiday, holidayable: @grandparent, date: Date.parse('03 Mar 2020'))
                @parent_holiday = create(:holiday, holidayable: @parent, date: Date.parse('04 Apr 2020'))
                @territory_holiday_1 = create(:holiday, holidayable: @territory, date: Date.parse('02 Mar 2020'))
                @territory_holiday_2 = create(:holiday, holidayable: @territory, date: Date.parse('06 Apr 2020'))
                @territory_holiday_3 = create(:holiday, holidayable: @territory, date: Date.parse('12 Dec 2020'))
                @territory_holiday_4 = create(:holiday, holidayable: @territory, date: Date.parse('15 Dec 2020'))
                @local_entity_holiday_1 = create(:holiday, holidayable: @local_entity, date: Date.parse('14 Dec 2020'))
            end
    
            it 'includes holidays in the interval' do
                start_date = Date.parse('11 Dec 2020')
                end_date = Date.parse('16 Dec 2020')
                expected = [
                    @territory_holiday_3,
                    @territory_holiday_4
                ]
    
                holidays_found = @territory.holidays_between(start_date, end_date)
    
                expect(holidays_found).to eq(expected)
            end
    
            it 'includes start date' do
                start_date = Date.parse('12 Dec 2020')
                end_date = Date.parse('13 Dec 2020')
                expected = [ @territory_holiday_3 ]
    
                holidays_found = @territory.holidays_between(start_date, end_date)
    
                expect(holidays_found).to eq(expected)
            end
    
            it 'includes end date' do 
                start_date = Date.parse('10 Dec 2020')
                end_date = Date.parse('12 Dec 2020')
                expected = [ @territory_holiday_3 ]
    
                holidays_found = @territory.holidays_between(start_date, end_date)
    
                expect(holidays_found).to eq(expected)
            end

            it 'includes parent\'s holidays recursively' do
                start_date = Date.parse('1 Mar 2020')
                end_date = Date.parse('7 Apr 2020')
                expected = [
                    @territory_holiday_1,
                    @grandparent_holiday,
                    @parent_holiday,
                    @territory_holiday_2
                ]
    
                holidays_found = @territory.holidays_between(start_date, end_date)

                expect(holidays_found).to eq(expected)
            end

            it 'local entities do not return parent municipality holidays' do
                start_date = Date.parse('10 Dec 2020')
                end_date = Date.parse('16 Dec 2020')
                expected = [ @local_entity_holiday_1 ]

                holidays_found = @local_entity.holidays_between(start_date, end_date)

                expect(holidays_found).to eq(expected)
            end
    
        end

    end # context holidays

    context 'order_by_relevance' do

        it 'municipalities with court go first, then by population' do

            municipio_nc2 = create(:territory, name: 'Municipio 4', population: 0, court: :no )
            municipio_nc1 = create(:territory, name: 'Municipio 3', population: 1000, court: :no )
            municipio_c2 = create(:territory, name: 'Municipio 2', population: 0, court: :have )
            municipio_c1 = create(:territory, name: 'Municipio 1', population: 1000, court: :have )

            expected = [
                municipio_c1,
                municipio_c2,
                municipio_nc1,
                municipio_nc2
            ]

            expect(Territory.by_relevance).to eq(expected)
        end

    end

    context 'similar_to scope' do

        before(:each) do
            @alcala = create(:territory, name: 'Alcala' )
            @calahorra = create(:territory, name: 'Calahorra' )
            @calcatta = create(:territory, name: 'Calcatta' )
            @la_costa_este = create(:territory, name: 'La Costa Este' )
            @sal_calada = create(:territory, name: 'Sal Calada' )
            @rabanos = create(:territory, name: 'Rábanos')
            @rabanera = create(:territory, name: 'Rabanera')
            @pollenca = create(:territory, name: 'Pollença')
            @perales = create(:territory, name:'Pe-/ra\'les')
        end

        it 'searches the complete name' do
            search_text = 'Calahorra'
            expected = [
                @calahorra
            ]
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'searches at the midle of the name' do
            search_text = 'atta'
            expected = [
                @calcatta
            ]
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'it\s not case-sensitive' do
            search_text = 'HoRRa'
            expected = [
                @calahorra
            ]
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)         
        end

        it 'works when there are no matches' do
            search_text = 'non existing Territory'
            expected = []
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'ignores spaces on database\'s name when searching' do
            search_text = 'lca'
            expected = [
                @alcala,
                @calcatta,
                @sal_calada
            ]
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'ignores spaces on search string when searching' do
            search_text = 'l ca'
            expected = [
                @alcala,
                @calcatta,
                @sal_calada
            ]
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

        it 'searches ignoring accents' do
            search_text = 'raba'
            expected = [
                @rabanos, @rabanera
            ]

            response = Territory.similar_to(search_text).to_a
            
            expect(response).to match_array(expected)
        end

        it 'searches ignoring special characters on database' do
            search_text = 'Perales'
            expected = [
                @perales
            ]

            response = Territory.similar_to(search_text).to_a
            
            expect(response).to match_array(expected)
        end

        it 'searches ignoring special characters on search string' do
            search_text = 'A-lc/a\'la'
            expected = [
                @alcala, @sal_calada
            ]

            response = Territory.similar_to(search_text).to_a
            
            expect(response).to match_array(expected)
        end

        it 'Ignores special characters and spaces' do
            vall_duixo = create(:territory, name: 'la Vall d\'Uixó' )

            search_text = 'lavalld'
            expected = [
                vall_duixo
            ]
            
            response = Territory.similar_to(search_text).to_a

            expect(response).to match_array(expected)
        end

    end # similar_to scope

end