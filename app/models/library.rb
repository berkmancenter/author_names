class Library < ActiveRecord::Base
  attr_accessible :name
  
  has_many :users
  
  def all_staff
    User.find(:all, :conditions => {:admin => true, :library_id => self.id})
  end
  
  def all_admin
    User.find(:all, :conditions => {:admin => true, :library_id => self.id})
  end
end
