class Author < ActiveRecord::Base
  attr_accessible :publisher_id, :user_id, :phone, :address_1, :address_2, :city, :state, :postal_code, :country
  
  belongs_to :publisher
  belongs_to :user
  
  def to_s
    self.user.full_name
  end
  
end
