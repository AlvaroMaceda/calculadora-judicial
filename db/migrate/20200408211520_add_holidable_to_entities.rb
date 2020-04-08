class AddHolidableToEntities < ActiveRecord::Migration[6.0]
  def change
    add_reference :countries, :holidable, polymorphic: true, null: true, index: { name: :index_countries_on_holidable }
    add_reference :autonomous_communities, :holidable, polymorphic: true, null: true, index: { name: :index_autonomous_communities_on_holidable }
    add_reference :municipalities, :holidable, polymorphic: true, null: true, index: { name: :index_municipalities_on_holidable }
  end
end
