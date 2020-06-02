class CreateTerritories < ActiveRecord::Migration[6.0]
  def change
    create_table :territories do |t|
      t.string :code
      t.string :name
      t.timestamps
      
      t.references :parent, null: true, index: true
      
      t.index :code, unique: true
    end
    add_foreign_key :territories, :territories, column: :parent_id
  end
end
