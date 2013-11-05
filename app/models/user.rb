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
  has_many :authors
  has_many :responses
  
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
    if !self.is_author? && !self.publisher.nil?
      return true
    end  
  end
  
  def is_author?
    if !self.authors.empty?
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
  
  def my_authors
    authors = Array.new
    if self.superadmin
      authors << Author.all
    elsif self.is_pub_admin? || self.is_pub_staff?
      #Author.all.collect{|author| author.publisher == self.publisher ? authors << author : ''} 
      authors = Author.all(:conditions => {:publisher_id => self.publisher.id})
    end
    return authors
  end
  
  def affiliation
    # spit out all publishers, libraries and/or author profiles associated with self.
  end
  
  def find_profile(publisher)
    p "in here"
    Author.first(:conditions => {:user_id => self.id, :publisher_id => publisher})
  end  
end
