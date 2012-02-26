require 'json'
require 'net/https'
require 'net/http'
require 'uri'
require 'openssl'

class FacebookImporter 
  attr_accessor :user_id, :token, :con
  attr_reader :family_list, :user_info
  
  TOKEN="AAADRgAhoADABAPCYJ8KhqO7F7aiKqHN62y7vJiakaIjqtoRobcIxSBJOokylsWbpGZARaV6u6uZBrwAngwPjhnnAmTHtZCn2LWYExmlDwZDZD"
  TESTUSER_ID="100000031321425"
  CON="family"
  
  def static_token
    @token=TOKEN
  end
  
  def set_token(token)
    @token=token
  end
  
  def static_user
    @user_id=TESTUSER_ID
  end
  
  def set_user(user_id)
    @user_id=user_id
  end
  
  def get_relatives
    uri=URI.parse("https://graph.facebook.com/#{user_id}/#{CON}?access_token=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl=true
    http.verify_mode=OpenSSL::SSL::VERIFY_NONE
    
    request=Net::HTTP::Get.new(uri.request_uri)
    
    response=http.request(request)
    @family_list = JSON(response.body)
  end
  
  def get_user_info
    uri=URI.parse("https://graph.facebook.com/#{user_id}?access_token=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl=true
    http.verify_mode=OpenSSL::SSL::VERIFY_NONE
    
    request=Net::HTTP::Get.new(uri.request_uri)
    
    response=http.request(request)
    @user_info = JSON(response.body)
  end
  
  def self.fetch_relatives
    user = self.new
    user.static_token
    user.static_user
    #id = user.get_user_info.fetch("id")
    #name = user.get_user_info.fetch("name")
    #firstname = user.get_user_info.fetch("first_name")
    #lastname = user.get_user_info.fetch("lastname")
    #birthdate = user.get_user_info.fetch("birthday")
    #gender = user.get_user_info.fetch("gender")
    #link = user.get_user_info.fetch("link")
    
    
    gotArray = user.get_relatives.fetch("data")   
    
    local = self.new
    local.static_token 
    
    gotArray.each_index do |i|
      id = gotArray.at(i).fetch('id')
      name = gotArray.at(i).fetch('name')
      relationship = gotArray.at(i).fetch('relationship')
      
      user.set_user(id)
      begin
        id = user.get_user_info.fetch("id")
        name = user.get_user_info.fetch("name")
        firstname = user.get_user_info.fetch("first_name")
        lastname = user.get_user_info.fetch("last_name")
        birthdate = user.get_user_info.fetch("birthday")
        gender = user.get_user_info.fetch("gender")
        link = user.get_user_info.fetch("link")
      rescue => e
        p e.message
        p user.get_user_info.update({"birthday"=>nil}).fetch("birthday")
      end 
      begin
        hometown_id = user.get_user_info.fetch("hometown").fetch("id")
        hometown = user.get_user_info.fetch("hometown").fetch("name").partition(/, /)[0]
        
        local.set_user(hometown_id)
        hometown_link = local.get_user_info.fetch("link")
      rescue => e
        p e.message
        p user.get_user_info.update({"hometown"=>nil}).fetch("hometown")
      end
      
      person = Person.find_or_initialize_by_url(link)
      person.update_attributes(:url => link, :firstname => firstname, :lastname => lastname, :birthdate => birthdate) # :thumbnail => thumbnail,
      
      place=Location.find_or_initialize_by_url(hometown_link)
      place.url = hometown_link
      place.name = hometown
      place.save
      person.residences.create(:location_id => place.id, :status => "birthplace")
      p person.inspect
    end
  end
end