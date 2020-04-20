module My
  module Matchers

    def match_response_schema(schema)
      BeJSonSuccessResponse.new schema
    end

    class BeJSonSuccessResponse

      SCHEMAS_DIRECTORY = "#{Dir.pwd}/spec/support/schemas"

      def initialize(schema)
        @last_error = ''
        @schema_path = schema_path(schema)
      end

      def matches?(response)
        begin
          JSON::Validator.validate!(@schema_path, response.body, strict: true)
          return true
        rescue StandardError => e
          @last_error = e
          return false
        end
      end

      def failure_message
        @last_error
      end

      private

      def schema_path(schema)
        @schema_path = "#{BeJSonSuccessResponse::SCHEMAS_DIRECTORY}/#{schema}.json"
      end

    end

  end
end

