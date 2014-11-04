class UsersController < ApplicationController
  before_filter :authenticate_superadmin_or_admin!, :except => [:edit, :update]
  
  def index
    @staff = current_user.my_staff
    @admin = current_user.my_admin
    @authors = current_user.my_authors
    @unassociated = current_user.my_unassigned
    @unaffiliated = User.all(:conditions => {:publisher_id => nil, :library_id => nil, :superadmin => false})
    @superadmins = User.all(:conditions => {:superadmin => true})
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.password = User.random_password
    params[:user_type] == "Author" ? @user.author = true : @user.author = false
    params[:user_type] == "Admin" ? @user.admin = true : @user.admin = false
    params[:user_type] == "Staff" ? @user.staff = true : @user.staff = false
    params[:user_type] == "Superadmin" ? @user.superadmin = true : @user.superadmin = false
  
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
    
    user = @user
    if @user.destroy
      flash[:notice] = %Q|Deleted user #{user.full_name_email}|
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
      unless params[:user][:library].nil?
        params[:user][:library_id] = Library.find_by_name(params[:user][:library]).id
      end
      unless params[:user][:publisher].nil?
        params[:user][:publisher_id] = Publisher.find_by_name(params[:user][:publisher]).id
      end  
    end  
    
    if current_user.try(:superadmin?) 
      if !@user.publisher.nil? && !params[:user][:library_id].nil?
        p "was publisher now library"
        params[:user][:publisher_id] = nil
      end
      if !@user.library.nil? && !params[:user][:publisher_id].nil?
        p "was library now publisher"
        params[:user][:library_id] = nil
      end
    end 
    params[:user] = params[:user].delete_if{|key, value| key == "publisher" || key == "library" }
    # admin = params[:user][:admin]
    # staff = params[:user][:staff]
    # author = params[:user][:author]
    # superadmin = params[:user][:superadmin]
    # params[:user] = params[:user].delete_if{|key, value| key == "admin" || key == "staff" || key == "author" || key == "superadmin" }
    
    @user.attributes = params[:user]
    params[:user_type] == "Author" ? @user.author = true : @user.author = false
    params[:user_type] == "Admin" ? @user.admin = true : @user.admin = false
    params[:user_type] == "Staff" ? @user.staff = true : @user.staff = false
    params[:user_type] == "Superadmin" ? @user.superadmin = true : @user.superadmin = false

    if @user.superadmin
      @user.publisher = nil
      @user.library = nil
    end  
    
    respond_to do|format|
      if @user.save
        unless @user.authors.nil?
          @user.authors.each do |a|
            a.email = @user.email
            a.first_name = @user.first_name
            a.last_name = @user.last_name
            a.save
          end  
        end
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
    respond_to do |format|
      unless params[:new_emails].blank?
        unless params[:publisher_id].nil? || params[:publisher_id].blank?
          emails.collect{|e| e.strip}.each do |email|
            current_user.send_new_publisher_user_email(email, "#{new_user_registration_path(:publisher_id => params[:publisher_id], :email => email)}") 
          end  
        end
        unless params[:library_id].nil? || params[:library_id].blank?
          emails.collect{|e| e.strip}.each do |email|
            current_user.send_new_library_user_email(email, "#{new_user_registration_path(:library_id => params[:library_id], :email => email)}") 
          end  
        end  
        format.html { redirect_to users_url, notice: 'Users were successfully invited.' }
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, notice: 'Please enter emails.' }
        format.json { head :no_content }
      end
    end
  end
end
