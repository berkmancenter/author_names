class WelcomeController < ApplicationController
  
  def index
    if current_user && current_user.is_author?
      @author_profile = current_user.authors.where(:publisher_id => current_user.publisher_id).first
    end 
  end
  
  def author_home
    @pub_id = params[:pub_id]
    if current_user.is_author?
      @author_profiles = current_user.authors
      @questionnaires = Questionnaire.all
    end    
    
  end
end
