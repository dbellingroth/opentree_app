class Person < ActiveRecord::Base
	attr_accessible	:url, :firstname, :lastname, :birthname, :sex, :birthdate, :deathdate, :birthplace, :birthplaceurl, :thumbnail
	
	has_many :residences, :dependent => :destroy
	has_many :locations, :through => :residences
	has_many :relations, :class_name => "Relation", :foreign_key => "base_person_id", :dependent => :destroy
	has_many :related_relations, :class_name => "Relation", :foreign_key => "related_person_id", :dependent => :destroy
	
	#RELATION_STATUSES=["uncle","aunt","mother","father","cousin"]
	
	scope :male, where(:sex => "male")
	scope :female, where(:sex => "female")
	def	relatives
		related_relations
	end
	
	def	uncles
		#related_relations.where(:status => "uncle")
	end
	
	def	nephews
		#relations.where(:status => "uncle")
	end
	
	def	set_uncle(person)
		#self.related_relations.create(:base_person_id => person.id, :status => "uncle")
	end
	
	def name
	  "#{lastname}, #{firstname}"
	end
		
end