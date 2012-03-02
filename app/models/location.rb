class Location < ActiveRecord::Base
  
  has_many :residences
  has_many :people, :through => :residences

  def self.find_by_person_last_name(lastname)
    l=Location.all
    cities = []
    l.each do |location|
      counter = location.residences.birthplaces.select{|residence|residence.person.lastname == lastname}.count
      cities << {:count => counter, :name => location.name, :lat => location.lat, :lon => location.lon} if counter > 0
    end
    cities
  end

end
