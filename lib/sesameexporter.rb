require 'rdf/sesame'

class SesameExporter
	def	self.export
    otbase = "http://erasmus.bellingroth.org/semanticweb/opentree.owl#"
    opentree = RDF::Sesame::Repository.new("http://localhost:8080/openrdf-sesame/repositories/opentree")
    Person.all.each do |p|
      
      person = RDF::URI.new(p.url)
      type = RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
      otp = RDF::URI.new("#{otbase}Person")
      statement = RDF::Statement.new(person, type, otp)
      opentree.insert(statement)
      
      a = RDF::URI.new(p.url)
      b = RDF::URI.new("#{otbase}hasFirstName")
      c = RDF::Literal.new(p.firstname)
      statement = RDF::Statement.new(a, b, c)
      opentree.insert(statement)
      
      a = RDF::URI.new(p.url)
      b = RDF::URI.new("#{otbase}hasLastName")
      c = RDF::Literal.new(p.lastname)
      statement = RDF::Statement.new(a, b, c)
      opentree.insert(statement)
      
      a = RDF::URI.new(p.url)
      b = RDF::URI.new("#{otbase}hasBirthName")
      c = RDF::Literal.new(p.birthname)
      statement = RDF::Statement.new(a, b, c)
      opentree.insert(statement)
      
      a = RDF::URI.new(p.url)
      b = RDF::URI.new("#{otbase}hasDateOfBirth")
      c = RDF::Literal.new(p.birthdate)
      statement = RDF::Statement.new(a, b, c)
      opentree.insert(statement)
      
      a = RDF::URI.new(p.url)
      type = RDF::URI.new("#{otbase}hasPlaceOfBirth")
      otp = RDF::URI.new(p.birthplaceurl)
      statement = RDF::Statement.new(person, type, otp)
      opentree.insert(statement) if p.birthplaceurl
    
    end
    
    Relation.all.each do |r|
      prop = ""
      case r.status
        when "uncle", "aunt"
          prop = "hasUncle"
        when "father", "mother"
          prop = "hasParent"
        when "brother", "sister"
          prop = "hasSibling"
        when "nephew", "niece"
          prop = "hasNephew"
      end
      
      p1 = Person.find_by_id(r.base_person_id)
      p2 = Person.find_by_id(r.related_person_id)
      a = RDF::URI.new(p1.url)
      b = RDF::URI.new("#{otbase}#{prop}")
      c = RDF::URI.new(p2.url)
      statement = RDF::Statement.new(a, b, c)
      opentree.insert(statement) if prop != "";
      
    end
    
  end
end