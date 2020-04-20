# https://stackoverflow.com/questions/38991873/can-i-use-a-built-in-rspec-matcher-in-a-custom-matcher
module My
    module Matchers
      def be_valid_responde(schema)
        BeValidResponse.new schema
      end
  
      class BeValidResponse
        include RSpec::Matchers
        include RSpec::Rails::Matchers::HaveHttpStatus
  
        def initialize(schema)
          @schema = schema
        end
  
        def matches?(response)
            # @foo = include module RSpec::Rails::Matchers::HaveHttpStatus
        #   actual = Addressable::URI.parse(url).query_values
        #   @matcher = include @expected
        #   @matcher.matches? actual


            # puts self.matcher_for_status
            puts '*****************'
            # puts self.have_http_status
            foo= self.have_http_status(response)
            puts response.status
            puts foo.matches? :success

            # puts '-----------'    
            # foo = have_http_status(:success)
            # puts foo.inspect
            # # puts foo.method_name
            # puts response.status
            # puts foo.matches? response
            # puts '-----------'
            # false
        end
  
        def failure_message
        #   @matcher.failure_message
            'Tlemendo error'
        end
  
      end
    end
  end