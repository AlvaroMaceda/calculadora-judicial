require 'rails_helper'
include My::Matchers

describe Api::DeadlineCalculatorController, type: :controller do

    render_views
    
    def error_message(response)
        JSON.parse(response.body)['message']
    end

    describe "GET #deadline/" do

        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
            Spain.create!
        end

        let(:correct_params) { 
            {
                municipality_code: Spain.benidorm.code,
                notification: '2020-09-21',
                days: 3
            }
        }

        it 'computes a deadline' do
            # See deadline_calculator_spec for examples of deadline calculations
            params = correct_params
            expected_deadline = '2020-09-24'
         
            get 'deadline', as: :json, params: params
            expect(response).to be_json_success_response("deadline_calculator")

            expected = params.merge({
                deadline: expected_deadline,
                holidays: [],
                missing_holidays: []
            }).to_json
            expect(response.body).to eq(expected)            
        end

        it 'works with local entities' do
            params = {
                municipality_code: Spain.benidoret.code,
                notification: '2020-09-21',
                days: 3
            }
            expected_deadline = '2020-09-24'

            get 'deadline', as: :json, params: params
            expect(response).to be_json_success_response("deadline_calculator")

            expected = params.merge({
                deadline: expected_deadline,
                holidays: [],
                missing_holidays: []
            }).to_json
            expect(response.body).to eq(expected)
        end

        it 'returns holidays for starting and end month' do
            params = {
                municipality_code: Spain.benidorm.code,
                notification: '2020-11-30',
                days: 3
            }
            expected_deadline = '2020-12-03'

            get 'deadline', as: :json, params: params
            expect(response).to be_json_success_response("deadline_calculator")

            expected = params.merge({
                deadline: expected_deadline,
                holidays: [
                    # November
                    holiday_api_data(Spain.holidays[:benidorm][:november_9]),
                    holiday_api_data(Spain.holidays[:benidorm][:november_10]),
                    # December
                    holiday_api_data(Spain.holidays[:benidorm][:december_10]),
                    holiday_api_data(Spain.holidays[:valencian_community][:december_7]),
                    holiday_api_data(Spain.holidays[:country][:december_8]),
                    holiday_api_data(Spain.holidays[:country][:december_25])
                ],
                missing_holidays: []
            }).to_json

            expect(response.body).to be_same_json_as(expected) 
        end

        it 'returns missing holidays' do
            params = {
                municipality_code: Spain.benidorm.code,
                notification: '2018-12-31',
                days: 1
            }
            expected_deadline = '2019-01-01'

            get 'deadline', as: :json, params: params
            expect(response).to be_json_success_response("deadline_calculator")

            expected = params.merge({
                deadline: expected_deadline,
                holidays: [],
                missing_holidays: [
                    { kind:Spain.country.kind, territory:Spain.country.name, years: [2018,2019] },
                    { kind:Spain.valencian_community.kind , territory:Spain.valencian_community.name, years: [2018,2019] },
                    { kind:Spain.benidorm.kind , territory:Spain.benidorm.name, years: [2018,2019] }
                ]
            }).to_json
            expect(response.body).to be_same_json_as(expected) 
        end

        context 'missing parameters' do
            it 'returns error if municipality code missing' do
                params = correct_params.except :municipality_code
    
                get 'deadline', as: :json, params: params
                
                expect(response).to be_json_error_response
                expect(error_message(response)).to include 'Municipality code can\'t be blank'
            end

            it 'returns error if notification date missing' do
                params = correct_params.except :notification
    
                get 'deadline', as: :json, params: params
                
                expect(response).to be_json_error_response
                expect(error_message(response)).to include 'Notification can\'t be blank'                
            end
            
            it 'returns error if days missing' do
                params = correct_params.except :days
                
                get 'deadline', as: :json, params: params
                
                expect(response).to be_json_error_response
                expect(error_message(response)).to include 'Days can\'t be blank'                     
            end

        end

        it 'returns error if municipality does not exist' do
            params = { **correct_params, municipality_code:'9999999' }

            get 'deadline', as: :json, params: params

            expect(response).to be_json_error_response
            expect(error_message(response)).to include 'Municipality not found'
        end

        it 'returns error if notification date is invalid' do
            params = { **correct_params, notification:'banana' }

            get 'deadline', as: :json, params: params

            expect(response).to be_json_error_response
            expect(error_message(response)).to include 'Notification Invalid date format. Expected yyyy-mm-dd'
        end

        it 'returns error if days is invalid' do
            params = { **correct_params, days:'banana' }

            get 'deadline', as: :json, params: params

            expect(response).to be_json_error_response
            expect(error_message(response)).to include 'Days is not a number'
        end

    end

end