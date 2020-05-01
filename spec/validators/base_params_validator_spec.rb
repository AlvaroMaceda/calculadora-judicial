require 'rails_helper'

describe BaseParamsValidator do

    it 'can be use as a base class' do
        
        class ClassForTesting_cbuaabc < BaseParamsValidator
        end

        expect { ClassForTesting_cbuaabc.new({}) }.not_to raise_error
    end

    it 'assigns the param values on initialization' do

        class ClassForTesting_atpvoi < BaseParamsValidator
            params :one, :two
        end

        actual_params = {
            one: 1,
            two: 'two'
        }

        validator = ClassForTesting_atpvoi.new(actual_params)

        expect(validator.one).to eq actual_params[:one]
        expect(validator.two).to eq actual_params[:two]
    end

    it 'only provides accessors for allowed params' do

        class ClassForTesting_opafap < BaseParamsValidator
            params :one, :two
        end

        actual_params = {
            one: 1,
            two: 'two',
            three: 3
        }

        validator = ClassForTesting_opafap.new(actual_params)

        expect{ validator.three }.to raise_error(NoMethodError)
    end

    it 'does not assign instance variables for not allowed params' do
       
        class ClassForTesting_dnaivfnap < BaseParamsValidator
            params :one, :two
        end

        actual_params = {
            one: 1,
            two: 'two',
            three: 3
        }

        validator = ClassForTesting_dnaivfnap.new(actual_params)

        expect(validator.instance_variables).not_to include(:@three)
    end

    it 'validates parameters as ActiveModel::Validations' do
        class ClassForTesting_vpaamv < BaseParamsValidator
            params :one, :two
            validates_presence_of :one
        end
        
        actual_params = {
            two: 'two'
        }

        validator = ClassForTesting_vpaamv.new(actual_params)

        expect(validator).not_to be_valid
    end

    it 'returns all error messages in a string' do

        class ClassForTesting_raemias < BaseParamsValidator
            params :one, :two
            validates_presence_of :one
            validates :two, presence: true, numericality: { only_integer: true } 
        end
        
        actual_params = {
            two: 'two'
        }

        validator = ClassForTesting_raemias.new(actual_params)
        validator.validate

        expected_errors = ["One can't be blank", "Two is not a number"]
        expected_message = expected_errors.join("; ")

        expect(validator.error_message).to eq(expected_message)
    end

end