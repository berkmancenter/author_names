class Publisher < ActiveRecord::Base
  attr_accessible :name, :contact_name, :phone, :email, :address_1, :city, :state, :postal_code, :country, :website
  
  has_many :users
  has_many :questionnaires
  has_many :authors
  has_many :form_items
  
  validates_presence_of :name, :contact_name, :phone, :email
  
  def to_s
    self.name
  end
  
  def all_staff
    User.find(:all, :conditions => {:staff => true, :publisher_id => self.id})
  end
  
  def all_admin
    User.find(:all, :conditions => {:admin => true, :publisher_id => self.id})
  end  
end
