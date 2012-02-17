class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :url
      t.string :name
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
