class QuestionnairesController < ApplicationController
  
  def index
    @questionnaires = Questionnaire.paginate(:page => params[:page], :per_page => 10)
  end
end
