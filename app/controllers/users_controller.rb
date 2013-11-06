class UsersController < ApplicationController
  before_filter :authenticate_superadmin_or_admin!, :except => [:edit, :update]
  
  def index
    if current_user.superadmin?
      @users = User.all
    elsif current_user.is_lib_admin?
      @users = current_user.library.users.order('email').paginate(:page => params[:page], :per_page => 50) 
    elsif current_user.is_pub_admin?
      @users = current_user.publisher.users.order('email').paginate(:page => params[:page], :per_page => 50)    
    end
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
    superadmin = params[:user][:superadmin]
    params[:user] = params[:user].delete_if{|key, value| key == "admin" || key == "staff" || key == "superadmin" }
    @user.attributes = params[:user]
    admin == "1" ? @user.admin = true : @user.admin = false
    staff == "1" ? @user.staff = true : @user.staff = false
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
    #@users = User.order('email').paginate(:page => params[:page], :per_page => 50)
  end
end
