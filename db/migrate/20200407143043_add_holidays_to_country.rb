class AddHolidaysToCountry < ActiveRecord::Migration[6.0]
  def change
    add_reference :countries, :holidayable, polymorphic: true, null: true, index: { name: 'index_country_on_holidays' }
  end
end
