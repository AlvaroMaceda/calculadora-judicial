class CreateAutonomousCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :autonomous_communities do |t|
      t.string :name
      t.belongs_to :Country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
