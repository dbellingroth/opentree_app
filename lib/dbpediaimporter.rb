require 'sparql/client'

class DbPediaImporter
	def	self.create_people_from_dbpedia(opts)
    dbpedia = SPARQL::Client.new("http://dbpedia.org/sparql")
    
    filter = ""
    opts.each do |k,v|
    	filter += "FILTER(?#{k} = '#{v}'@en). "
    end
    query = "SELECT DISTINCT ?person ?firstname ?lastname ?birthdate ?birthplace ?birthplacename ?thumbnail ?bplat ?bplon WHERE {
    ?person rdf:type foaf:Person .
    ?person foaf:givenName ?firstname .
    ?person foaf:surname ?lastname .
    ?person dbpedia-owl:birthDate ?birthdate .
    ?person dbpedia-owl:birthPlace ?birthplace .
    ?birthplace rdfs:label ?birthplacename .
    ?birthplace geo:lat ?bplat.
    ?birthplace geo:long ?bplon.
    ?person dbpedia-owl:thumbnail ?thumbnail .
		#{filter}
    }"
		result = dbpedia.query(query)

    result.each do |solution|
      person_url = solution.to_hash[:person].to_s
      firstname = solution.to_hash[:firstname].to_s
      lastname = solution.to_hash[:lastname].to_s
      birthdate = solution.to_hash[:birthdate].to_s
      birthplace_url = solution.to_hash[:birthplace].to_s
      birthplacename = solution.to_hash[:birthplacename].to_s
      thumbnail = solution.to_hash[:thumbnail].to_s
      lat = solution.to_hash[:bplat].to_s.to_f
      lon = solution.to_hash[:bplon].to_s.to_f

 			person = Person.find_or_initialize_by_url(person_url)
      person.update_attributes(:url => person_url, :firstname => firstname, :lastname => lastname, :thumbnail => thumbnail, :birthdate => birthdate)
      
      place=Location.find_or_initialize_by_url(birthplace_url)
      place.url = birthplace_url
      place.name = birthplacename
      place.lat = lat
      place.lon = lon
      place.save
      person.residences.create(:location_id => place.id, :status => "birthplace")
      p person.inspect 
	  end
  end
end