module ApplicationHelper
  def display_person_count
    "There are #{Person.count} people in the app"
  end
  
  def persons_relations_count(person)
    person.relatives.count
  end
end
