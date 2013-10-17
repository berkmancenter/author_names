class AuthorsController < ApplicationController
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
        format.html { redirect_to authors_url, notice: 'Author was successfully created.' }
        format.json { render json: @author, status: :created, author: @author }
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
        format.html { redirect_to authors_url, notice: 'Author was successfully updated.' }
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
      format.html { redirect_to authors_url }
      format.json { head :no_content }
    end
  end
  
  def bulk_authors
    emails = Array.new  
    unless params[:new_emails].blank?
      emails << params[:new_emails].split(",").each{|e| e.strip!}
      emails.flatten!
    end
    
    emails.each do |email|
      author = Author.new(:email => email, :publisher_id => params[:publisher_id])
      author.first_name = ""
      author.last_name = ""
      author.phone = ""
      author.address_1 = ""
      author.city = ""
      author.state = ""
      author.postal_code = ""
      author.country = ""
      author.save
    end
    
    respond_to do |format|
      format.html { redirect_to authors_path, notice: 'Done.' }
      format.json { head :no_content }
    end
  end  
end
