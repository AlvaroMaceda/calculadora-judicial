class CreateHolidays < ActiveRecord::Migration[6.0]
  def change
    create_table :holidays do |t|
      t.date :date
      t.references :holidayable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
