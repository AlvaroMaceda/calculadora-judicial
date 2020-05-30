class AddTypeToTerritory < ActiveRecord::Migration[6.0]
  def change
    add_column :territories, :kind, :string
    add_index :territories, :kind
  end
end
