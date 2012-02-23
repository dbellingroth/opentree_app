require 'dbpediaimporter'
require 'sesameexporter'

class HomeController < ApplicationController
  def index
    redirect_to people_path
  end
  
  def importfromdbpedia
  	DbPediaImporter.create_people_from_dbpedia()
  	redirect_to people_path
  end
  
  def importfromfacebook
  	DbPediaImporter.create_people_from_dbpedia()
  	redirect_to people_path
  end
  
  def exporttosesame
  	SesameExporter.export
  	redirect_to people_path
  end
end
