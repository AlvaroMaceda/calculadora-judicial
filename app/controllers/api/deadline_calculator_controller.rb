class Api::DeadlineCalculatorController < ApplicationController

    before_action :validate_parameters
    before_action :parse_parameters

    def deadline()
        municipality = Municipality.find_by(code: @municipality_code)
        @deadline = DeadlineCalculator.new(municipality).deadline(@notification_date, @days)
    end

    def parse_parameters
        @municipality_code = params[:municipality_code]
        @notification_date = Date.parse(params[:notification])
        @days = params[:days].to_i
        # params[:param1].present? && params[:param2].present?
        # required = [:one, :two, :three]
        # if required.all? {|k| params.has_key? k}
        # true
    end
      
    def validate_parameters
        # params.require([:municipality_code, :notification, :days])

        # if !check_parameters
        #     render json:  {
        #         error:  {
        #                     message: "Bad Request, parameters missing.",
        #                     status: 500
        #                 }
        #     }
        # end
    end

  end