class BirthplacezeugsEntfernt < ActiveRecord::Migration
  def change
    remove_column :people, :birthplace
    remove_column :people, :birthplaceurl
  end
end
