class CreateTerritories < ActiveRecord::Migration[6.0]
  def change
    create_table :territories do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.timestamps
      
      t.references :parent, null: true, index: true
      
      t.index :code, unique: true
    end
    add_foreign_key :territories, :territories, column: :parent_id
  end
end
