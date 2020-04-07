class AddHolidaysToMunicipality < ActiveRecord::Migration[6.0]
  def change
    add_reference :municipalities, :holidayable, polymorphic: true, null: true
  end
end
