class AddSearchableNameToTerritory < ActiveRecord::Migration[6.0]
  def change
    add_column :territories, :searchable_name, :string, null: false
  end
end
