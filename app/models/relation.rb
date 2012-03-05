class Relation < ActiveRecord::Base
  belongs_to :person, :class_name => "Person", :foreign_key => "base_person_id"
  belongs_to :related_person, :class_name => "Person", :foreign_key => "related_person_id"
end