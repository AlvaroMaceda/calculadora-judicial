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
          
          puts '****************'
          puts response.body
          puts @schema_file_tmp
          puts @schemer.valid?(response.body)
          puts '------------------'
          error = @schemer.validate(response.body).to_a
          puts error.inspect
          puts '****************'
          if not @schemer.valid?(response.body)
            @last_error = ''
            return true            
          else
            # This will return the error but it is unintelligible
            # error = @schemer.validate(response.body)
            @last_error = 'Invalid schema'
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

