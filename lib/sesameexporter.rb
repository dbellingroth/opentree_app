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
    
    end
  end
end