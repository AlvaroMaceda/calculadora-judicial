class ChangePrimaryKeyOfMunicipalities < ActiveRecord::Migration[6.0]
  def change

    drop_table :municipalities

    # create_table :municipalities do |t|
    #   t.string :code, limit: 5
    #   t.string :name
    #   t.references :autonomous_community, null: false, foreign_key: true

    #   t.timestamps
    # end
    # add_index :municipalities, :code, unique: true

    create_table :municipalities, {
      id: false,
      primary_key: :code
    } do |t|
      t.string :code, limit: 5
      t.string :name
      t.references :autonomous_community, null: false, foreign_key: true

      t.timestamps
    end
    add_index :municipalities, :code, unique: true

  end
end
