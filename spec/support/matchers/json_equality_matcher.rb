require 'json'

module My
    module Matchers

        def be_same_json_as(expected_json)
            BeSameJSon.new expected_json
        end
  
        class BeSameJSon

            include RSpec::Matchers
            include RSpec::Rails::Matchers

            def initialize(expected_json)
                @expected_json = expected_json
            end
    
            # We won't check json schema if response code is not the expected
            def matches?(received_json)
                @comparison_result = JSON.compare(@expected_json, received_json)
                return @comparison_result.result
            end
    
            def failure_message
                "JSON differs at path #{@comparison_result.error_path}"
            end        
        end
        
    end
  end