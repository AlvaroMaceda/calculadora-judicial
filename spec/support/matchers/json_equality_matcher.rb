# require 
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
                begin
                    comparison_result = JsonUtilities.compare_json(expected_json, received_json)
                rescue # This is to get the key with the error
                end
                # return comparison_result
                return false 
            end
    
            def failure_message
                'TO-DO'
            end        
        end
        
    end
  end