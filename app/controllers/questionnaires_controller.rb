class QuestionnairesController < ApplicationController
  
  def index
    if current_user.try(:superadmin?)
      @questionnaires = Questionnaire.all
    elsif current_user.is_pub_admin? || current_user.is_pub_staff?
      @questionnaires = Questionnaire.all(:conditions => {:publisher_id => current_user.publisher.id})
    elsif current_user.is_author?
      redirect_to('/') and return
    end    
  end
  
  def show
    @questionnaire = Questionnaire.find(params[:id])
    if !params[:gather_response].nil?
      redirect_to gather_response_questionnaires_url(:answers => params[:gather_response])
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
    params[:questionnaire][:publisher] = Publisher.find_by_name(params[:questionnaire][:publisher])
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
    params[:answers].each_value do |value|
      response = Response.create(value)
    end  
    
    redirect_to questionnaires_url, notice: 'Response was successfully recorded.'
  end  
  
  def send_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id].to_i)
    @publisher = @questionnaire.publisher
    @authors = @publisher.authors
    
    # respond_to do |format|
#       unless params[:emails].nil?
#         format.html { redirect_to questionnaires_url, notice: 'Questionnaire was successfully sent.' }
#         format.json { head :no_content }
#       else
#         format.html { redirect_to send_questionnaire_questionnaires_path(:questionnaire_id => @questionnaire), notice: 'Please select authors.' }
#         format.json { head :no_content }
#       end
#     end
    
  end
end
