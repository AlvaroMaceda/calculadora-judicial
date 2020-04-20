RSpec::Matchers.define :match_response_schema do |schema|
    match do |response|
      schema_directory = "#{Dir.pwd}/spec/support/schemas"
      schema_path = "#{schema_directory}/#{schema}.json"
      begin
        JSON::Validator.validate!(schema_path, response.body, strict: true)
      rescue StandardError => e
        @error = e
        return false
      end
    end

    failure_message do |actual_monster|
      @error
    end
    
  end