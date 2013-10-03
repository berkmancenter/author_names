class WelcomeController < ApplicationController
  
  def index   
  end
  
  def author_home
    @pub_id = params[:pub_id]
    if current_user.is_author?
      @author_profiles = current_user.authors
      @questionnaires = Questionnaire.all
    end    
    
  end
end
