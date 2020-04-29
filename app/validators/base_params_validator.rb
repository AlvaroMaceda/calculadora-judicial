class BaseParamsValidator
    include ActiveModel::Validations

    class << self
        def params(*allowed_params)
            # How to store allowed params?
            self.send(:attr_accessor, *allowed_params)
        end
    end

    def initialize(param_values)
        # I need to access allowed_params here to filter allowed ones
        param_values.each do |name, value| 
            instance_variable_set("@#{name}", value) 
        end
    end    
end   