require 'dbpediaimporter'
require 'sesameexporter'
require 'facebookimporter'

class HomeController < ApplicationController
  def index
    redirect_to people_path
  end
  
  def importfromdbpedia
  	params.delete("action")
  	params.delete("controller")
  	DbPediaImporter.create_people_from_dbpedia(params)
  	redirect_to people_path
  end
  
  def importfromfacebook
  	FacebookImporter.fetch_relatives()
  	redirect_to people_path
  end
  
  def exporttosesame
  	SesameExporter.export
  	redirect_to people_path
  end    
end