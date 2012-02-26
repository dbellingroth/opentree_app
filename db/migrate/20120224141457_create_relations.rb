class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :base_person_id
      t.integer :related_person_id
      t.string :status

      t.timestamps
    end
  end
end
