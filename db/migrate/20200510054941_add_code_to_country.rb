class AddCodeToCountry < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :code, :string
    # add_index :moderators, :username, unique: tru
    add_index :countries, :code, unique: true
  end
end
