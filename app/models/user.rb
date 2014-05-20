class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :staff, :author, :first_name, :last_name, :publisher_id, :library_id, :username
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
    if self.is_lib_admin? || self.is_lib_staff?
      return true
    end  
  end  
  
  def is_publisher?
    if self.is_pub_admin? || self.is_pub_staff?
      return true
    end  
  end
  
  def is_author?
    if self.author
      return true
    end  
  end
  
  def is_lib_admin?
    self.try(:admin?) && !self.library.nil?
  end  
  
  def is_lib_staff?
    self.try(:staff?) && !self.library.nil?
  end 
  
  def is_pub_admin?
    self.try(:admin?) && !self.publisher.nil?
  end 
  
  def is_pub_staff?
    self.try(:staff?) && !self.publisher.nil?
  end 
  
  def my_authors
    authors = Array.new
    if self.superadmin
      authors = User.all(:conditions => {:author => true})
    elsif self.is_pub_admin? || self.is_pub_staff?
      authors = User.all(:conditions => {:publisher_id => self.publisher.id, :author => true})
    elsif self.is_lib_admin? || self.is_lib_staff?
      authors = User.all(:conditions => {:library_id => self.library.id, :author => true})  
    end
    return authors
  end
  
  def my_staff
    staff = Array.new
    if self.superadmin
      staff = User.all(:conditions => {:staff => true})
    elsif self.is_pub_admin? || self.is_pub_staff?
      staff = User.all(:conditions => {:publisher_id => self.publisher.id, :staff => true})
    elsif self.is_lib_admin? || self.is_lib_staff?
      staff = User.all(:conditions => {:library_id => self.library.id, :staff => true})   
    end
    return staff
  end
  
  def my_admin
    admin = Array.new
    if self.superadmin
      admin = User.all(:conditions => {:admin => true})
    elsif self.is_pub_admin? || self.is_pub_staff?
      admin = User.all(:conditions => {:publisher_id => self.publisher.id, :admin => true})
    elsif self.is_lib_admin? || self.is_lib_staff?
      admin = User.all(:conditions => {:library_id => self.library.id, :admin => true})   
    end
    return admin
  end
  
  def my_unassigned
    unassigned = Array.new
    if self.superadmin
      unassigned = User.all(:conditions => ["admin is not true and staff is not true and author is not true"])
    elsif self.is_pub_admin? || self.is_pub_staff?
      unassigned = User.all(:conditions => ["admin is not true and staff is not true and author is not true and publisher_id = ?", self.publisher.id])
    elsif self.is_lib_admin? || self.is_lib_staff?
      unassigned = User.all(:conditions => ["admin is not true and staff is not true and author is not true and publisher_id = ?", self.library.id])   
    end
    return unassigned
  end
  
  def affiliation
    # spit out all publishers, libraries and/or author profiles associated with self.
  end
  
  def find_profile(publisher)
    Author.first(:conditions => {:user_id => self.id, :publisher_id => publisher})
  end  
  
  def send_new_user_email(emails, path)
    # send to selected users
    Email.create(
      :from => self.publisher.email,
      :reply_to => self.publisher.email,
      :to => self.publisher.email,
      :bcc => emails.join(", "),
      :subject => "[Author Names] Please Sign Up",
      :body => "<p>Please <a href='#{ROOT_URL}#{path}'>create</a> an account.</p>"
    )   
  end 
end
