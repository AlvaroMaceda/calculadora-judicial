class ValidateUniquenessOfHolidays < ActiveRecord::Migration[6.0]
  def change
    add_index :holidays, [:holidayable_type, :holidayable_id, :date], unique: true
  end
end