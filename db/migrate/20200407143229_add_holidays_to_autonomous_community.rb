class AddHolidaysToAutonomousCommunity < ActiveRecord::Migration[6.0]
  def change
    add_reference :autonomous_communities, :holidayable, polymorphic: true, null: true, index: { name: 'index_autonomous_communities_on_holidays' }
  end
end
