class QuestionnairesController < ApplicationController
  
  def index
    @questionnaires = Questionnaire.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @questionnaire = Questionnaire.find(params[:id])
    if !params[:gather_response].nil?
      redirect_to gather_response_questionnaires_url(:responses => params[:gather_response])
    end  
  end
  
  def new
    @questionnaire = Questionnaire.new
  end
  
  def edit
    @questionnaire = Questionnaire.find(params[:id])
  end
  
  def create
    params[:questionnaire][:publisher] = Publisher.find_by_name(params[:questionnaire][:publisher])
    @questionnaire = Questionnaire.new(params[:questionnaire])
    
    respond_to do |format|
      if @questionnaire.save
        format.html { redirect_to questionnaires_url, notice: 'Questionnaire was successfully created.' }
        format.json { render json: @questionnaire, status: :created, questionnaire: @questionnaire }
      else
        format.html { render action: "new" }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @questionnaire = Questionnaire.find(params[:id])

    respond_to do |format|
      if @questionnaire.update_attributes(params[:questionnaire])
        format.html { redirect_to questionnaires_url, notice: 'Questionnaire was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @questionnaire = Questionnaire.find(params[:id])
    @questionnaire.destroy

    respond_to do |format|
      format.html { redirect_to questionnaires_url }
      format.json { head :no_content }
    end
  end  
  
  def gather_response
    p "in gather response"
    p params[:responses]
    response = Response.new()
    redirect_to questionnaires_url, notice: 'Response was successfully recorded.'
  end  
end
