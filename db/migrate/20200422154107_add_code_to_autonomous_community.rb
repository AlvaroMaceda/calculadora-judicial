class AddCodeToAutonomousCommunity < ActiveRecord::Migration[6.0]
  def change
    add_column :autonomous_communities, :code, :string
    add_index :autonomous_communities, [:country_id, :code], unique: true
  end
end
