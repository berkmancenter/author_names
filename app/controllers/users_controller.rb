class UsersController < ApplicationController
  before_filter :authenticate_superadmin_or_admin!, :except => [:edit, :update]
  
  def index
    @staff = current_user.my_staff
    @admin = current_user.my_admin
    @authors = current_user.my_authors
    @unassociated = current_user.my_unassigned
    @unaffiliated = User.all(:conditions => {:publisher_id => nil, :library_id => nil})
  end
  
  def new
    @user = User.new
  end
  
  def create
    admin = params[:user][:admin]
    staff = params[:user][:staff]
    superadmin = params[:user][:superadmin]
    params[:user] = params[:user].delete_if{|key, value| key == "admin" || key == "staff" || key == "superadmin" }
    @user = User.new(params[:user])
    @user.password = User.random_password
    admin == "1" ? @user.admin = true : @user.admin = false
    staff == "1" ? @user.staff = true : @user.staff = false
    superadmin == "1" ? @user.superadmin = true : @user.superadmin = false
  
    respond_to do|format|
      if @user.save
        flash[:notice] = 'Added that User'
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not add that User'
        format.html {render :action => :new}
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    
    unless current_user.try(:superadmin?) || current_user.try(:admin?) || @user.email == current_user.email
       redirect_to('/') and return
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    unless current_user.try(:superadmin?) || current_user.try(:admin?) || @user.email == current_user.email
       redirect_to('/') and return
    end
    
    user = @user.email
    if @user.destroy
      flash[:notice] = %Q|Deleted user #{user}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @user = User.find(params[:id])
    unless current_user.try(:superadmin?) || current_user.try(:admin?) || @user.email == current_user.email
       redirect_to('/') and return
    end
    
    unless current_user.try(:superadmin?) 
      if params[:assign_library].nil?
        params[:user][:library_id] = nil
      elsif params[:assign_library] == "1" || params[:assign_library] == ""
        lib = Library.find(current_user.library.id)
        params[:user][:library_id] = lib.id
      end
      if params[:assign_publisher].nil?
        params[:user][:publisher_id] = nil
      elsif params[:assign_publisher] == "1" || params[:assign_publisher] == ""
        pub = Publisher.find(current_user.publisher.id)
        params[:user][:publisher_id] = pub.id
      end  
    end  
    
    
    admin = params[:user][:admin]
    staff = params[:user][:staff]
    author = params[:user][:author]
    superadmin = params[:user][:superadmin]
    params[:user] = params[:user].delete_if{|key, value| key == "admin" || key == "staff" || key == "author" || key == "superadmin" }
    @user.attributes = params[:user]
    admin == "1" ? @user.admin = true : @user.admin = false
    staff == "1" ? @user.staff = true : @user.staff = false
    author == "1" ? @user.author = true : @user.author = false
    superadmin == "1" ? @user.superadmin = true : @user.superadmin = false
    respond_to do|format|
      if @user.save
        flash[:notice] = %Q|#{@user} updated|
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not update that User'
        format.html {render :action => :new}
      end
    end
  end
  
  def authors
    @authors = current_user.my_authors
  end
  
  def make_staff
    @user = User.find(params[:id])
    @user.staff = true
    @user.save
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was changed to Staff.' }
    end
    
  end  
  
  def bulk_users
    emails = Array.new  
    unless params[:new_emails].blank?
      emails << params[:new_emails].split(",").each{|e| e.strip!}
      emails.flatten!
    end
    
    # emails.each do |email|
#       author = Author.new(:email => email, :publisher_id => params[:publisher_id])
#       author.first_name = ""
#       author.last_name = ""
#       author.phone = ""
#       author.address_1 = ""
#       author.city = ""
#       author.state = ""
#       author.postal_code = ""
#       author.country = ""
#       author.save
#     end
    
    respond_to do |format|
      unless params[:new_emails].blank?
        current_user.send_new_user_email(emails.collect{|e| e.strip}, "#{new_user_registration_path(:publisher_id => current_user.publisher.id)}") 
        format.html { redirect_to users_url, notice: 'Users were successfully invited.' }
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, notice: 'Please enter emails.' }
        format.json { head :no_content }
      end
    end
  end
end
