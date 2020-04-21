class ValidateUniquenessOfHolidays < ActiveRecord::Migration[6.0]
  def change
    add_index :holidays, [:holidayable, :date], unique: true
  end
end