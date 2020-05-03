require 'rails_helper'
include My::Matchers

describe Api::DeadlineCalculatorController, type: :controller do

    render_views

    describe "GET #deadline/" do

        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
            Spain.create!
        end

        let(:correct_params) { 
            {
                municipality_code: Spain.benidorm.code,
                notification: '2020-11-25',
                days: 15
            }
        }

        def error_message(response)
            JSON.parse(response.body)['message']
        end

        it 'computes a deadline' do
            # See deadline_calculator_spec for examples of deadline calculations
            params = correct_params
            expected_deadline = '2020-12-21'
         
            get 'deadline', as: :json, params: params

            puts response.body

            expect(response).to be_json_success_response("deadline_calculator")

            expected = params.merge({
                deadline: expected_deadline
            }).to_json
            expect(response.body).to eq(expected)            
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