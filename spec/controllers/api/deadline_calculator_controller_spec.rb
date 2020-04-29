require 'rails_helper'
include My::Matchers

describe Api::DeadlineCalculatorController, type: :controller do

    render_views

    describe "GET #deadline/" do

        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
            Spain.create!
        end

        it 'computes a deadline' do
            # See deadline_calculator_spec for examples of deadline calculations
            params = {
                municipality_code: Spain.benidorm.code,
                notification: '2020-11-25',
                days: 15
            }
            expected_deadline = '2020-12-21'
         
            get 'deadline', as: :json, params: params

            expect(response).to be_json_success_response("deadline_calculator")

            puts response.body

            expected = params.merge({
                deadline: expected_deadline
            }).to_json
            expect(response.body).to eq(expected)            
        end

        context 'missing parameters' do
            xit 'returns error if municipality code missing'
            xit 'returns error if notification date missing'
            xit 'returns error if days missing'
        end

        xit 'returns error if municipality does not exist' do
        end

        xit 'returns error if notification date is invalid' do
            params = {
                municipality_code: Spain.benidorm.code,
                notification: 'banana',
                days: 15
            }

            get 'deadline', as: :json, params: params

            # https://cloud.google.com/blog/products/api-management/restful-api-design-what-about-errors
            expect(response).to be_json_error_response("deadline_calculator")
        end

        xit 'returns error if days is invalid' do
        end

    end

end