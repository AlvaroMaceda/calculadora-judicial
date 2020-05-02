class ValidDateValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
        return if value.nil? # We can have a nil value if data is not required
        begin
            Date.strptime(value, '%Y-%m-%d')
        rescue ArgumentError => error
            record.errors[attribute] << 'Invalid date format. Expected yyyy-mm-dd'
        end
    end

  end
  