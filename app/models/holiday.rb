class Holiday < ApplicationRecord
  belongs_to :holidable, polymorphic: true
end
