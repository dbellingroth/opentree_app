require 'dbpediaimporter'
require 'sesameexporter'
require 'facebookimporter'

class HomeController < ApplicationController

  def index
    redirect_to people_path
  end
  
  def	importer
  end
  
  def importfromdbpedia
  	count= Person.count
  	DbPediaImporter.create_people_from_dbpedia(params["person"].select{|k,v|!v.blank?})
  	new_count=Person.count
  	redirect_to people_path, :notice => "Es wurden #{new_count - count} Personen importiert"
  end
  
  def importfromfacebook
  	FacebookImporter
  	redirect_to people_path
  end
  
  def exporttosesame
  	SesameExporter.export
  	redirect_to people_path
  end
  
  def map
  	render 'home/map'
  end
  
  def mapdata
  	lastname = params["lastname"]
  	people = Person.find_all_by_lastname(lastname)
  	locations = []
  	
  	people.each do |p|
  		p.residences.each do |r|
  			if r.status == "birthplace"
  				locations << Location.find_by_id(r.location_id)
  			end
  		end
  	end
  	
  	locationlist = locations.map do |l|
  			{ :lat => l.lat, :lon => l.lon, :count => 1 }
		end
		
  	render :json => locationlist.as_json
		#render :json => {:location => Location.first.as_json(:only => [:name, :lat, :lon]) }
  end
  
end