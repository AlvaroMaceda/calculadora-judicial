class ChangePrimaryKeyOfAutonomousCommunity < ActiveRecord::Migration[6.0]
  def change

    # drop_table :autonomous_communities
    
    create_table :autonomous_communities, {
      id: false,
      primary_key: :code
    } do |t|
      t.string :code, limit: 2
      t.string :name
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
    add_index :autonomous_communities, :code, unique: true

  end
end
