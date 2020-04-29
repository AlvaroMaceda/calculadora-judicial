class BaseParamsValidator
    include ActiveModel::Validations

    def initialize(params)
        params.each do |name,value| 
            instance_variable_set("@#{name}", value) 
            # self.class.send(:attr_accessor, name)
        end
    end    
end   