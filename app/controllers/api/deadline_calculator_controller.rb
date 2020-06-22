class Api::DeadlineCalculatorController < ApplicationController

    before_action :validate_parameters
    before_action :parse_parameters

    def deadline()
        # sleep 1 # For manual UI testing purposes
        settlement = Territory.settlements.find_by(code: @municipality_code)
        return json_error 'Municipality not found' if settlement.nil?
        
        @deadline = get_deadline(settlement)
        @holidays_affected = get_holidays_to_show(settlement, @notification_date, @deadline)
        @missing_holidays = get_missing_holidays(settlement)
    end

    private 

    def get_deadline(settlement)
        DeadlineCalculator.new(settlement).deadline(@notification_date, @days)
    end

    def get_missing_holidays(settlement)
        settlement.holidays_missing_between(@notification_date.year,@deadline.year)
    end

    def get_holidays_to_show(settlement, notification, deadline)
        first_date = notification.beginning_of_month
        last_date = deadline.end_of_month
        settlement.holidays_between(first_date, last_date)
    end

    def parse_parameters
        @municipality_code = params[:municipality_code]
        @notification_date = Date.parse(params[:notification])
        @days = params[:days].to_i
    end
      
    def validate_parameters
        validator = ParamsValidator.new(params)
        if validator.invalid?
            json_error validator.error_message
        end
    end

    class ParamsValidator < BaseParamsValidator
        params :municipality_code, :notification, :days

        validates :municipality_code, 
            presence: true, 
            allow_blank: false

        validates :notification, presence: true, valid_date: true

        validates :days, presence: true, numericality: { only_integer: true }        
    end   

  end