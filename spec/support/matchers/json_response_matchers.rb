# https://stackoverflow.com/questions/38991873/can-i-use-a-built-in-rspec-matcher-in-a-custom-matcher
module My
    module Matchers

        def be_json_success_response(schema)
            BeJSonResponse.new schema, :success
        end
  
        def be_json_error_response(schema = 'error_response')
            BeJSonResponse.new schema, :bad_request
        end
  
        class BeJSonResponse

            include RSpec::Matchers
            include RSpec::Rails::Matchers

            def initialize(expected_schema, expected_http_status)
                @schema_matcher = match_response_schema(expected_schema)
                @status_matcher = have_http_status(expected_http_status)
            end
    
            # We won't check json schema if response code is not the expected
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