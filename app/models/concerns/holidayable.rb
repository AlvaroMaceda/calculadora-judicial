module Holidayable
    extend ActiveSupport::Concern
  
    included do
      has_many :holidays, :as => :holidayable
    end
end