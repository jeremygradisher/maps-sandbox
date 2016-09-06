class AddMapIdToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :map_id, :integer
  end
end
