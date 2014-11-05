class Author < ActiveRecord::Base
  attr_accessible :publisher_id, :user_id, :phone, :address_1, :address_2, :city, :state, :postal_code, :country, :email, :first_name, :last_name
  
  belongs_to :publisher
  belongs_to :user
  has_many :publications, :dependent => :destroy
  
  validates_presence_of :publisher_id, :user_id
  
  def to_s
    self.full_name
  end
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  def full_name_email
    return "#{self.last_name}, #{self.first_name} (#{self.email})"
  end
  
  def can_delete?
    a = true
    self.publications.each do |pub|
      if !pub.lib_exported_flag || !pub.pub_exported_flag
        a = false
        break
      end    
    end
    return a
  end  
  
end
