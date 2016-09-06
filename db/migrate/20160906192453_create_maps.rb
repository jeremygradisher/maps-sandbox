class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
