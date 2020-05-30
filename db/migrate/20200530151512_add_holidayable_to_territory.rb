class AddHolidayableToTerritory < ActiveRecord::Migration[6.0]
    def change
        add_reference :territories, :holidayable, polymorphic: true, null: true, index: { name: :index_territories_on_holidable }
    end
end
