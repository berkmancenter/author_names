class Author < ActiveRecord::Base
  attr_accessible :publisher_id, :user_id, :phone, :address_1, :address_2, :city, :state, :postal_code, :country, :email, :first_name, :last_name
  
  belongs_to :publisher
  belongs_to :user
  
  def to_s
    self.full_name
  end
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
end
