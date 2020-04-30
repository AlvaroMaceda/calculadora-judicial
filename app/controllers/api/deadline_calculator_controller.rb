class Api::DeadlineCalculatorController < ApplicationController

    before_action :validate_parameters
    before_action :parse_parameters

    def deadline()
        municipality = Municipality.find_by(code: @municipality_code)
        @deadline = DeadlineCalculator.new(municipality).deadline(@notification_date, @days)
    end

    private 

    def parse_parameters
        @municipality_code = params[:municipality_code]
        @notification_date = Date.parse(params[:notification])
        @days = params[:days].to_i
    end
      
    def validate_parameters
        validator = ParamsValidator.new(params)
        if validator.invalid?
            render status: :bad_request, json: { error: validator.errors }
        end
    end

    class ParamsValidator < BaseParamsValidator
        params :municipality_code, :notification, :days

        validates :municipality_code, 
            presence: true, 
            length: {minimum: 5, maximum: 5}, 
            allow_blank: false

        validates :notification, presence: true, valid_date: true

        validates :days, presence: true, numericality: { only_integer: true }        
    end   

  end