class ChangeIndexesOfMunicipality < ActiveRecord::Migration[6.0]
  def change
    remove_index :municipalities, :code
    add_index :municipalities, [:autonomous_community_id, :code], unique: true
  end
end
