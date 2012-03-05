class Relation < ActiveRecord::Base
  belongs_to :person, :class_name => "Person", :foreign_key => "base_person_id"
  belongs_to :related_person, :class_name => "Person", :foreign_key => "related_person_id"
  
  
  
  def relative_person(person)
    if self.person == person
      self.related_person
    else
      self.person
    end
  end
  
  def self.new_relation_for_people(p1, status, p2) 
    p1.relations.create(:related_person_id => p2.id, :status => status)
    case status
      when "nephew","niece"
        p2.relations.create(:related_person_id => p1.id, :status => p2.sex== "male" ? "uncle" : "aunt")
      when "brother","sister"
        p2.relations.create(:related_person_id => p1.id, :status => p1.sex== "male" ? "brother" : "sister")
      when "mother","father"
        p2.relations.create(:related_person_id => p1.id, :status => p2.sex== "male" ? "son" : "daughter")
      when "uncle","aunt"
        p2.relations.create(:related_person_id => p1.id, :status => p2.sex== "male" ? "nephwe" : "niece")
    end
  end
  
end