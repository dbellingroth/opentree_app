class Person < ActiveRecord::Base
	attr_accessible	:url, :firstname, :lastname, :birthname, :sex, :birthdate, :deathdate, :birthplace, :birthplaceurl, :thumbnail
	
	has_many :residences
	has_many :locations, :through => :residences
	
end
