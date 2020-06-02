class AddTypeToTerritory < ActiveRecord::Migration[6.0]
  def change
    add_column :territories, :kind, :string, null: false
    add_index :territories, :kind
  end
end
