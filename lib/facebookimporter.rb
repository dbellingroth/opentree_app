require 'json'
require 'net/https'
require 'net/http'
require 'uri'
require 'openssl'
require 'date'

class FacebookImporter
  def initialize(person_id, token)
    @person_id = person_id
    @token = token
  end
    
  def get_relatives
    uri = URI.parse("https://graph.facebook.com/#{@person_id}/family?access_token=#{@token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri)
    
    response = http.request(request)
    relatives = JSON(response.body)
    
    relatives.fetch("data").each do |fbperson|
      @person_id = fbperson.fetch("id")
      @name = fbperson.fetch("name")
      @relation = fbperson.fetch("relationship")
      get_info(@person_id)
    end
  end
  
  def get_info(person_id)
    uri = URI.parse("https://graph.facebook.com/#{person_id}?access_token=#{@token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri)
    
    response = http.request(request)
    fb_obj = JSON(response.body)
    
    @person_id = fb_obj.fetch("id")
    @firstname = fb_obj.fetch("first_name")
    @lastname = fb_obj.fetch("last_name")
    if !fb_obj.key?("gender")
      @sex = fb_obj.update({"gender"=>"no gender"}).fetch("gender")
    else
      @sex = fb_obj.fetch("gender")
    end
    @person_link = fb_obj.fetch("link")
    get_thumbnail(@person_id)
    
    if !fb_obj.key?("birthday")
      @birthdate = fb_obj.update({"birthday"=>"01/01/1001"}).fetch("birthday")
    else
      @birthdate = fb_obj.fetch("birthday")
    end
     
    if !fb_obj.key?("hometown")
      fb_obj.update({"hometown"=>"no hometown"})
      @hometown_id = "no cityid avaiable"
      @hometown_name = "no city avaiable"
      @hometown_link = "no citylink avaiable"
    else
      @hometown_id = fb_obj.fetch("hometown").fetch("id")
      @hometown_name = fb_obj.fetch("hometown").fetch("name")
      get_latlong(@hometown_id)
    end
    
    person = Person.find_or_initialize_by_url(@person_link)
    person.update_attributes(:url => @person_link, :firstname => @firstname, :lastname => @lastname, :sex => @sex, :birthdate => @birthdate, :birthplace => @hometown_name, :birthplaceurl => @hometown_link, :thumbnail => @profile_pic_url, )
    place = Location.find_or_initialize_by_url(@hometown_link)
    place.url = @hometown_link
    place.name = @hometown_name
    place.lat = @hometown_lat
    place.lon = @hometown_long
    place.save
    person.residences.create(:location_id => place.id, :status => "birthplace")
    p person.inspect
  end
  
  def get_thumbnail(person_id)
    @profile_pic_url = "https://graph.facebook.com/#{person_id}/picture"
  end
  
  def get_latlong(hometown_id)
    uri = URI.parse("https://graph.facebook.com/#{hometown_id}?access_token=#{@token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri)
    
    response = http.request(request)
    location_info = JSON(response.body)
    @hometown_lat = location_info.fetch("location").fetch("latitude")
    @hometown_long = location_info.fetch("location").fetch("longitude")
    @hometown_link = location_info.fetch("link")
  end
  
end

test_person_id = "630819600" 
test_token = "AAADRgAhoADABAPCYJ8KhqO7F7aiKqHN62y7vJiakaIjqtoRobcIxSBJOokylsWbpGZARaV6u6uZBrwAngwPjhnnAmTHtZCn2LWYExmlDwZDZD"

person = FacebookImporter.new(test_person_id, test_token)
person.get_relatives

