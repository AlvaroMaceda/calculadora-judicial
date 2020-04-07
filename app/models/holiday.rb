class Holiday < ApplicationRecord
  belongs_to :holidayable, polymorphic: true
end
