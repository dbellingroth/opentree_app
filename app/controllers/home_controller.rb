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
		test_token = "AAADRgAhoADABAPCYJ8KhqO7F7aiKqHN62y7vJiakaIjqtoRobcIxSBJOokylsWbpGZARaV6u6uZBrwAngwPjhnnAmTHtZCn2LWYExmlDwZDZD"
		count= Person.count
		fb_importer = FacebookImporter.new(params[:person][:facebook_id], test_token)
		fb_importer.get_relatives
  	new_count=Person.count
  	redirect_to people_path, :notice => "Es wurden #{new_count - count} Personen importiert"
  end
  
  def exporttosesame
  	SesameExporter.export
  	redirect_to people_path
  end
  
  def map
  	render 'home/map'
  end
  
  def mapdata
		render :json => Location.find_by_person_last_name(params["lastname"]).as_json
  end
  
end