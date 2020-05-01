class ValidDateValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
        begin
            Date.strptime(value, '%Y-%m-%d')
        rescue ArgumentError => error
            record.errors[attribute] << 'Invalid date format. Expected yyyy-mm-dd'
        end
    end

  end
  