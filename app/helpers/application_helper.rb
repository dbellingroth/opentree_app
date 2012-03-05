module ApplicationHelper
  def display_person_count
    "There are #{Person.count} people in the app"
  end
end
