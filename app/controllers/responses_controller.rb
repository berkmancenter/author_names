class ResponsesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user.is_pub_admin? || current_user.is_pub_staff?
      @questionnaires = Questionnaire.all(:conditions => {:publisher_id => current_user.publisher.id})
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
      format.html { redirect_to questionnaires_url }
      format.json { head :no_content }
    end
  end  
  
  def author_response
    @questionnaire = Questionnaire.find(params[:questionnaire].to_i)
    @user = User.find(params[:user].to_i)
    if current_user.is_pub_admin? || current_user.is_pub_staff?
      @responses = Response.all(:conditions => {:questionnaire_id => @questionnaire.id, :user_id => @user.id})
      p "responses"
      p @responses  
    end 
  end  
end
