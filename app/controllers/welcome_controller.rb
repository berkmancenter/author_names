class WelcomeController < ApplicationController
  
  def index
    @questionnaires = Questionnaire.all
  end
end
