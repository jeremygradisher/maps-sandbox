class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.text :info
      t.string :status
      t.string :coords

      t.timestamps null: false
    end
  end
end
