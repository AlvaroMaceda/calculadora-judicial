class ValidDateValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)

      # options[:message]
      record.errors[attribute] << 'Terrible error'

    end

  end
  