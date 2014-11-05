class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :staff, :author, :first_name, :last_name, :publisher_id, :library_id, :username, :publisher, :library
  # attr_accessible :title, :body
  
  belongs_to :publisher
  belongs_to :library
  has_many :authors, dependent: :destroy
  has_many :responses, :dependent => :destroy
  has_many :publications, :dependent => :destroy
  
  SUPER_USER_TYPES = ["", "Superadmin", "Admin", "Staff", "Author"]
  USER_TYPES = ["", "Admin", "Staff", "Author"]
  
  def to_s
    self.full_name
  end
  
  def can_delete?
    a = true
    self.responses.each do |resp|
      if !resp.lib_exported_flag || !resp.pub_exported_flag
        a = false
        break
      end    
    end
    return a
  end
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
  def full_name_email
    return "#{self.last_name}, #{self.first_name} (#{self.email})"
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
  
  def user_type
    if self.author
      return "Author"
    elsif self.staff
      return "Staff"
    elsif self.admin
      return "Admin"
    elsif self.superadmin
      return "Superadmin"
    else
      return "Unassigned"  
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
      unassigned = User.all(:conditions => ["admin is not true and staff is not true and author is not true and superadmin is not true"])
    elsif self.is_pub_admin? || self.is_pub_staff?
      unassigned = User.all(:conditions => ["admin is not true and staff is not true and author is not true and publisher_id = ?", self.publisher.id])
    elsif self.is_lib_admin? || self.is_lib_staff?
      unassigned = User.all(:conditions => ["admin is not true and staff is not true and author is not true and library_id = ?", self.library.id])   
    end
    return unassigned
  end
  
  def affiliation
    if !self.publisher.nil?
      return self.publisher.name
    elsif !self.library.nil?
      return self.library.name
    else
      return "Unaffiliated"
    end      
  end
  
  def find_profile(publisher)
    Author.first(:conditions => {:user_id => self.id, :publisher_id => publisher})
  end  
  
  def send_new_publisher_user_email(email, path)
    # send to selected users
    Email.create(
      :from => self.publisher.nil? ? self.email : self.publisher.email,
      :reply_to => self.publisher.nil? ? self.email : self.publisher.email,
      :to => email,
      :subject => "[Author Names] Please Sign Up",
      :body => "<p>Please <a href='#{ROOT_URL}#{path}'>create</a> an account.</p>"
    )   
  end 
  
  def send_new_library_user_email(email, path)
    # send to selected users
    Email.create(
      :from => self.library.nil? ? self.email : self.library.email,
      :reply_to => self.library.nil? ? self.email : self.library.email,
      :to => email,
      :subject => "[Author Names] Please Sign Up",
      :body => "<p>Please <a href='#{ROOT_URL}#{path}'>create</a> an account.</p>"
    )   
  end 
end
