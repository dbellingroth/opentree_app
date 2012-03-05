module PeopleHelper
  def relative_name(person, relation)
    if relation.person == person
      relation.related_person.name
    else
      relation.person.name
    end
  end
end
