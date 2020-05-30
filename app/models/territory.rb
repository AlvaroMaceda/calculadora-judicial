
class Territory < ApplicationRecord
    belongs_to :parent, optional: true, class_name: "Territory"
    has_many :territories, class_name: "Territory", foreign_key: "parent"

    validates :code, 
        presence: true, 
        allow_blank: false,
        uniqueness: true

    validates :name, 
        presence: true, 
        allow_blank: false

end
