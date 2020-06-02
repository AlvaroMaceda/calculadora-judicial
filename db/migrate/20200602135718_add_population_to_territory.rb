class AddPopulationToTerritory < ActiveRecord::Migration[6.0]
  def change
    add_column :territories, :population, :integer, default: 0, null: false
  end
end
