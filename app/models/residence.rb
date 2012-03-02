class Residence < ActiveRecord::Base
  belongs_to :person
  belongs_to :location
  
  scope :birthplaces, where("status = 'birthplace'")
end
