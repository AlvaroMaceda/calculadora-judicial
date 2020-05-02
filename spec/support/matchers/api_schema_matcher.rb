module My
  module Matchers

    def match_response_schema(schema)
      BeJSonSuccessResponse.new schema
    end

    class BeJSonSuccessResponse

      SCHEMAS_DIRECTORY = "#{Dir.pwd}/spec/support/schemas"

      def initialize(schema_file)
        @last_error = ''
        @schema_file_tmp = schema_path(schema_file)
        schema = Pathname.new(schema_path(schema_file))
        @schemer = JSONSchemer.schema(schema)
      end

      def matches?(response)
          errors = @schemer.validate(JSON.parse(response.body)).to_a
          if errors.empty?
            @last_error = ''
            return true            
          else
            @last_error = error_message(errors)
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

      def error_message(errors)
        # I've been unable to obtain a meaningful message from json_schemer output
        'Invalid schema'
      end

    end

  end
end

