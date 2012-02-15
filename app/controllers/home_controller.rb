require 'dbpediaimporter'

class HomeController < ApplicationController
  def index
    DbPediaImporter.create_people_from_dbpedia()
  end
end
