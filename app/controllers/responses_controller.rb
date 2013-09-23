class ResponsesController < ApplicationController
  
  def index
    @responses = Response.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @response = Response.find(params[:id])
    if !params[:gather_response].nil?
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
end
