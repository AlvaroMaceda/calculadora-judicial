# https://stackoverflow.com/questions/38991873/can-i-use-a-built-in-rspec-matcher-in-a-custom-matcher
module My
    module Matchers
      def be_json_success_responde(schema)
        BeJSonSuccessResponse.new schema
      end
  
      class BeJSonSuccessResponse

        include RSpec::Matchers
        include RSpec::Rails::Matchers

        def initialize(schema)
          @schema = schema
          @status_matcher = have_http_status(:success)
          @schema_matcher = match_response_schema("municipality_search")
        end
  
        # We won't check json schema if response is not :success
        def matches?(response)
            @status_ok = @status_matcher.matches? response
            return false unless @status_ok
            @schema_matcher.matches? response
        end
  
        def failure_message
          return @status_matcher.failure_message unless @status_ok
          @schema_matcher.failure_message
        end        

      end
    end
  end