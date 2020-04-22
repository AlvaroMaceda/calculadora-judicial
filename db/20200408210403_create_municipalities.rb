class CreateMunicipalities < ActiveRecord::Migration[6.0]
  def change
    create_table :municipalities do |t|
      t.string :code, limit: 5
      t.string :name
      t.references :autonomous_community, null: false, foreign_key: true

      t.timestamps
    end
    add_index :municipalities, :code, unique: true
  end
end
