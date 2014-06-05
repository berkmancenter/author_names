class AuthorsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user.try(:superadmin?)
      @authors = Author.all
    elsif current_user.is_pub_admin? || current_user.is_pub_staff?
      @authors = Author.all(:conditions => {:publisher_id => current_user.publisher.id}) 
    end 
  end
  
  def new
    @author = Author.new
  end
  
  def edit
    @author = Author.find(params[:id])
  end
  
  def create
    @author = Author.new(params[:author])
    respond_to do |format|
      if @author.save
        if current_user.is_author?
          format.html { redirect_to root_url, notice: 'Author was successfully created.' }
          format.json { render json: @author, status: :created, author: @author }
        else  
          format.html { redirect_to authors_url, notice: 'Author was successfully created.' }
          format.json { render json: @author, status: :created, author: @author }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @author = Author.find(params[:id])

    respond_to do |format|
      if @author.update_attributes(params[:author])
        if current_user.try(:superadmin?) || current_user.try(:admin?)
          format.html { redirect_to authors_url, notice: 'Author was successfully updated.' }
        else   
          format.html { redirect_to root_url, notice: 'Thank you. Your profile was successfully updated.' }
        end  
        format.json { head :no_content }  
      else
        format.html { render action: "edit" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @author = Author.find(params[:id])
    @author.destroy

    respond_to do |format|
      format.html { redirect_to authors_url, notice: 'Author was successfully deleted.' }
      format.json { head :no_content }
    end
  end  
end
