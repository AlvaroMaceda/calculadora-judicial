class AddCourtToTerritory < ActiveRecord::Migration[6.0]
  def change
    add_column :territories, :court, :string, default: 0
  end
end
