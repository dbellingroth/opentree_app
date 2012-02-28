class Location < ActiveRecord::Base
  
  has_many :residences
  has_many :people, :through => :residences

end
