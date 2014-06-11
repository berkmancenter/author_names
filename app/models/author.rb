class Author < ActiveRecord::Base
  attr_accessible :publisher_id, :user_id, :phone, :address_1, :address_2, :city, :state, :postal_code, :country, :email, :first_name, :last_name
  
  belongs_to :publisher
  belongs_to :user
  has_many :publications
  
  validates_presence_of :publisher_id
  
  def to_s
    self.full_name
  end
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  def full_name_email
    return "#{self.last_name}, #{self.first_name} (#{self.email})"
  end
  
end
