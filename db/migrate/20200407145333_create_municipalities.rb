class CreateMunicipalities < ActiveRecord::Migration[6.0]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.belongs_to :AutonomousCommunity, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
