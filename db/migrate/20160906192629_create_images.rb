class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :map_id
      t.string :image
      t.string :width
      t.string :height

      t.timestamps null: false
    end
  end
end
