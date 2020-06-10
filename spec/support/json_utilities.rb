# Modified from https://gist.github.com/binarydev/aeb35977a2ad22eeaea1

module JSON

    extend self

    # compares two json objects (Array, Hash, or String to be parsed) for equality
    def compare(json1, json2)

        raise ComparisonError.new('Can only compare JSON strings, Arrays or Hashes') unless  (json1.is_a?(String) || json1.is_a?(Hash) || json1.is_a?(Array))
        raise ComparisonError.new('Expected same class for both parameters') unless json1.class == json2.class
            
        # Parse objects to JSON if Strings
        json1,json2 = [json1,json2].map! do |json|
            json.is_a?(String) ? JSON.parse(json) : json
        end
        
        begin
            do_compare_json(json1,json2)
        rescue ComparisonError => e
            return ComparisonResult.new(false, e.message)
        end

        return ComparisonResult.new(true)
    end
    
    private
    
    def do_compare_json(json1,json2,path="$")
        # It raises an error if finds a difference
        
        if(json1.is_a?(Array))
            do_compare_json_array(json1,json2,path)
        elsif(json1.is_a?(Hash))
            do_compare_json_hash(json1,json2,path)
        else
            raise ComparisonError.new(path) unless (json1==json2)
        end
    end

    def do_compare_json_array(json1,json2,path)
        json1.each_with_index do |obj, index|
            json1_obj, json2_obj = obj, json2[index]
            do_compare_json(json1_obj, json2_obj,path+"[#{index}]")
        end
    end

    def do_compare_json_hash(json1,json2,path)
        json1.each do |key,value|
            current_path = path+".#{key}"

            raise ComparisonError.new(current_path) unless json2.respond_to?(:has_key?) && json2.has_key?(key)
            json1_val, json2_val = value, json2[key]

            if(json1_val.is_a?(Array) || json1_val.is_a?(Hash))
                do_compare_json(json1_val, json2_val,current_path)
            else
                raise ComparisonError.new(current_path) unless (json1_val == json2_val)
            end
            
        end
    end

    class ComparisonResult
        attr_reader :result, :error_path

        def initialize(result,error_path='')
            @result = result
            @error_path = error_path
        end

        def ==(other)
            return @result==other if is_boolean?(other)
            return @result==other.result && @error_path==other.error_path if other.instance_of?(ComparisonResult)
            return false
        end
        alias_method :eql?, :==

        def true?
            @result
        end

    private

        def is_boolean?(value)
            [true, false].include? value
        end
    end

    class ComparisonError < JSONError
    end

end