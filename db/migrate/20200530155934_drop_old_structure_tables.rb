class DropOldStructureTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :municipalities
    drop_table :autonomous_communities
    drop_table :countries
  end
end
