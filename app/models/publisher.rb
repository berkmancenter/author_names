class Publisher < ActiveRecord::Base
  attr_accessible :name, :contact_name, :phone, :email, :address_1, :address_2, :city, :state, :postal_code, :country, :website, :description, :logo, :remove_logo
  
  has_many :users
  has_many :questionnaires, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :form_items, :dependent => :destroy
  has_many :publications
  has_many :form_item_groups
  
  validates_presence_of :name, :contact_name, :phone, :email, :address_1, :city, :state, :postal_code, :country
  
  mount_uploader :logo, LogoUploader
  
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
