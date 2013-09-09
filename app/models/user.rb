class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :staff, :first_name, :last_name, :publisher_id, :library_id, :username
  # attr_accessible :title, :body
  
  belongs_to :publisher
  belongs_to :library
  belongs_to :author
  
  def to_s
    self.full_name
  end
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  def self.random_password(size = 11)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end
  
  def is_librarian?
    if !self.library.nil?
      return true
    end  
  end  
  
  def is_publisher?
    if !self.publisher.nil?
      return true
    end  
  end
  
  def is_author?
    if self.library.nil? && self.publisher.nil?
      return true
    end  
  end
  
  def is_lib_admin?
    self.try(:admin?) && self.is_librarian?
  end  
  
  def is_lib_staff?
    self.try(:staff?) && self.is_librarian?
  end 
  
  def is_pub_admin?
    self.try(:admin?) && self.is_publisher?
  end 
  
  def is_pub_staff?
    self.try(:staff?) && self.is_publisher?
  end 
  
end
