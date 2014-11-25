class AuthorsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user.try(:superadmin?)
      @authors = Author.all
    elsif current_user.is_publisher?
      @authors = Author.all(:conditions => {:publisher_id => current_user.publisher.id}) 
    end 
  end
  
  def new
    if current_user.is_librarian?
       redirect_to('/') and return
    end
    unless params[:user_id].nil?
      user = User.find(params[:user_id])
      @author = Author.new(:email => user.email, :first_name => user.first_name, :last_name => user.last_name, :user_id => user.id)
    else  
      @author = Author.new
    end  
  end
  
  def edit
    @author = Author.find(params[:id])
  end
  
  def show
    @author = Author.find(params[:id])
  end  
  
  def create
    @author = Author.new(params[:author])
    respond_to do |format|
      if @author.save
        unless @author.user.nil?
          @author.user.email = @author.email
          @author.user.first_name = @author.first_name
          @author.user.last_name = @author.last_name
          @author.user.save
        end  
        if current_user.is_author?
          if params[:questionnaire].nil?
            format.html { redirect_to root_url, notice: 'Contact info was successfully recorded.' }
          else
            format.html { redirect_to questionnaire_url(params[:questionnaire], :publication => params[:publication]), notice: 'Thank you. Your contact info was successfully created.' }  
          end  
          format.json { render json: @author, status: :created, author: @author }
        else  
          if params[:questionnaire].nil?
            format.html { redirect_to authors_url, notice: 'Author was successfully created.' }
          else
            format.html { redirect_to questionnaire_url(params[:questionnaire], :publication => params[:publication], :author_user_id => @author.user.id), notice: 'Contact info was successfully created.' }  
          end
          format.json { render json: @author, status: :created, author: @author }
        end
      else
        flash[:error] = "Please fill out all required fields."
        format.html { render action: "new" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @author = Author.find(params[:id])
    
    respond_to do |format|
      if @author.update_attributes(params[:author])
        unless @author.user.nil?
          @author.user.email = @author.email
          @author.user.first_name = @author.first_name
          @author.user.last_name = @author.last_name
          @author.user.save
        end
        if current_user.try(:superadmin?) || current_user.try(:admin?)
          if params[:questionnaire].nil?
            format.html { redirect_to authors_url, notice: 'Contact Info was successfully updated.' }
          else
            format.html { redirect_to questionnaire_url(params[:questionnaire], :publication => params[:publication], :author_user_id => @author.user.id), notice: 'Thank you. OAQ has updated the author’s contact information that you just supplied. Fill out the questionnaire below on behalf of the author.' }  
          end
        else 
          if params[:questionnaire].nil?
            format.html { redirect_to root_url, notice: 'Contact info was successfully updated.' }
          else
            format.html { redirect_to questionnaire_url(params[:questionnaire], :publication => params[:publication]), notice: 'Thank you. Your contact info was successfully updated.' }  
          end
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
    author = @author
    @author.destroy

    respond_to do |format|
      format.html { redirect_to authors_url, notice: "#{author.full_name_email} was successfully deleted." }
      format.json { head :no_content }
    end
  end  
end
