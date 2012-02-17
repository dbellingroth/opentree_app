class CreateResidences < ActiveRecord::Migration
  def change
    create_table :residences do |t|
      t.integer :person_id
      t.integer :location_id
      t.string  :status
      t.timestamps
    end
  end
end
