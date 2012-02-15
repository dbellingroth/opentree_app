require 'sparql/client'

class DbPediaImporter
	def	self.create_people_from_dbpedia
    dbpedia = SPARQL::Client.new("http://dbpedia.org/sparql")
		result = dbpedia.query('SELECT DISTINCT ?person ?firstname ?lastname ?birthdate ?birthplace ?birthplacename ?thumbnail WHERE {
    ?person rdf:type foaf:Person .
    ?person foaf:givenName ?firstname .
    ?person foaf:surname ?lastname .
    ?person dbpedia-owl:birthDate ?birthdate .
    ?person dbpedia-owl:birthPlace ?birthplace .
    ?birthplace rdfs:label ?birthplacename .
    ?person dbpedia-owl:thumbnail ?thumbnail .
    FILTER(?birthplacename = "Gummersbach"@en)
    }')

    result.each do |solution|
      person = solution.to_hash[:person].to_s
      firstname = solution.to_hash[:firstname].to_s
      lastname = solution.to_hash[:lastname].to_s
      birthdate = solution.to_hash[:birthdate].to_s
      birthplace = solution.to_hash[:birthplace].to_s
      birthplacename = solution.to_hash[:birthplacename].to_s
      thumbnail = solution.to_hash[:thumbnail].to_s
 
      person = Person.create(:url => person, :firstname => firstname, :lastname => lastname, :thumbnail => thumbnail)
      p person.inspect 
	  end
  end
end