class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :url
      t.string :firstname
      t.string :lastname
      t.string :birthname
      t.string :sex
      t.date :birthdate
      t.date :deathdate
      t.string :birthplace
      t.string :birthplaceurl
      t.string :thumbnail

      t.timestamps
    end
  end
end
