require 'csv'

class ResponsesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    unless current_user.is_author?
      if current_user.is_pub_admin? || current_user.is_pub_staff?
        @questionnaires = Questionnaire.all(:conditions => {:publisher_id => current_user.publisher.id})
      elsif current_user.is_lib_admin? || current_user.is_lib_staff?
        @questionnaires = Questionnaire.all
      end  
      @response_hash = Hash.new
      @questionnaires.each do |q|
        @response_hash[q] = {}
        q.responses.each do |r|
          if @response_hash[q][r.user_id].nil?
            @response_hash[q][r.user_id] = []
          end  
          @response_hash[q][r.user_id]<< r
        end   
      end
      
      unless params[:csv].nil?
        @csv = params[:csv]
        @user = params[:user].to_i
      end  
    end 
  end
  
  def show
    @response = Response.find(params[:id])
    unless params[:gather_response].nil?
      redirect_to gather_response_questionnaires_url(:responses => params[:gather_response])
    end  
  end
  
  def new
    @response = Response.new
  end
  
  def edit
    @response = Response.find(params[:id])
  end
  
  def create
    params[:questionnaire][:publisher] = Publisher.find_by_name(params[:questionnaire][:publisher])
    @response = Response.new(params[:questionnaire])
    
    respond_to do |format|
      if @response.save
        format.html { redirect_to questionnaires_url, notice: 'Response was successfully created.' }
        format.json { render json: @response, status: :created, questionnaire: @response }
      else
        format.html { render action: "new" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @response = Response.find(params[:id])

    respond_to do |format|
      if @response.update_attributes(params[:questionnaire])
        format.html { redirect_to questionnaires_url, notice: 'Response was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @response = Response.find(params[:id])
    @response.destroy

    respond_to do |format|
      format.html { redirect_to questionnaires_url, notice: 'Response was successfully deleted.' }
      format.json { head :no_content }
    end
  end  
  
  def author_response
    @questionnaire = Questionnaire.find(params[:questionnaire].to_i)
    @user = User.find(params[:user].to_i)
    if current_user.is_pub_admin? || current_user.is_pub_staff? || current_user.is_lib_admin? || current_user.is_lib_staff?
      @responses = Response.all(:conditions => {:questionnaire_id => @questionnaire.id, :user_id => @user.id})
      p "responses"
      p @responses  
    end 
  end
  
  def export_single
    @csv = nil
    @questionnaire = Questionnaire.find(params[:questionnaire].to_i)
    @user = User.find(params[:user].to_i)
    @author = Author.find(:first, :conditions => {:user_id => @user.id, :publisher_id => @questionnaire.publisher.id})
    @form_items = @questionnaire.form_items
    @author_headers = Author.columns.collect {|a| a.name }-["id", "publisher_id", "user_id", "created_at", "updated_at"]
    @form_headers = @form_items.collect {|item| item.field_name }
    @headers = @author_headers + @form_headers
    @responses = Response.all(:conditions => {:questionnaire_id => @questionnaire.id, :user_id => @user.id})
 
    CSV.open("#{Rails.root}/public/uploads/export_single_#{@user.id}.csv", "w") do |csv|
      csv << @headers
      row = Array.new
      @author_headers.each do |ah|
        row << @author.send(ah)
      end  
      @form_items.each do |item|
        response = @responses.select{|resp| resp.form_item_id == item.id}[0]
        unless response.nil?
          row << [response.response_text]
        else
          row << [""]  
        end  
      end
      row.flatten!
      csv << row
    end
    flash[:notice] = 'Export has been generated! Please click Download CSV.'
    @csv = true
    redirect_to responses_path(:questionnaire => @questionnaire.id, :csv => @csv, :user => @user)
  end  
  
  def export
    if current_user.is_pub_admin? || current_user.is_pub_staff?
      @questionnaires = Questionnaire.all(:conditions => {:publisher_id => current_user.publisher.id})
    elsif current_user.is_lib_admin? || current_user.is_lib_staff?
      @questionnaires = Questionnaire.all
    end
    @csv_export = nil
    @response_hash = Hash.new
    @questionnaires.each do |q|
      @response_hash[q] = {}
      q.responses.each do |r|
        if @response_hash[q][r.user_id].nil?
          @response_hash[q][r.user_id] = []
        end  
        @response_hash[q][r.user_id]<< r
      end   
    end
    p "response hash"
    p @response_hash  
    
	  @response_hash.each_key do |questionnaire| 
	    CSV.open("#{Rails.root}/public/uploads/export_#{questionnaire.name.gsub(/ /, '-')}.csv", "w") do |csv|
        @author_headers = Author.columns.collect {|a| a.name }-["id", "publisher_id", "user_id", "created_at", "updated_at"]  
        @form_items = questionnaire.form_items
        @form_headers = @form_items.collect {|item| item.field_name }
        @headers = @author_headers + @form_headers
        csv << @headers
        
        @response_hash[questionnaire].each_key do |user| 
          @user = User.find(user)
          @author = Author.find(:first, :conditions => {:user_id => @user.id, :publisher_id => questionnaire.publisher.id})
          @responses = Response.all(:conditions => {:questionnaire_id => questionnaire.id, :user_id => @user.id})
          row = Array.new
          @author_headers.each do |ah|
            row << @author.send(ah)
          end  
          @form_items.each do |item|
            response = @responses.select{|resp| resp.form_item_id == item.id}[0]
            unless response.nil?
              row << [response.response_text]
            else
              row << [""]  
            end  
          end
          row.flatten!
          csv << row
        end
	    end 
    end 
    @csv_export = true
  end
      
end
