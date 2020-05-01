class BaseParamsValidator
    include ActiveModel::Validations

    class << self
        attr_accessor :allowed_params

        def params(*allowed_params)
            @allowed_params = allowed_params
            self.send(:attr_accessor, *allowed_params)
        end
    end

    def initialize(param_values)
        # This is done for security: class is initialized with params and that is 
        # a variable provided by the users
        param_values.select { |name,_|
            self.class.allowed_params.include? name.to_sym
        }.each do |name, value| 
            instance_variable_set("@#{name}", value) 
        end
    end

    def error_message
        errors.full_messages.join("; ")
    end
end