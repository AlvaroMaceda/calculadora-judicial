class ValidDateValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)

        puts value
        begin
            Date.strptime(value, '%Y-%m-%d')
        # catch 
        rescue ArgumentError => error
            record.errors[attribute] << 'Invalid date format. Expected yyyy-mm-dd'
        end
        # options[:message]
        # record.errors[attribute] << 'Terrible error'

    end

  end
  