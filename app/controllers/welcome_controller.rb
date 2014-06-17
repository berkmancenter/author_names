class WelcomeController < ApplicationController
  
  def index
    if current_user && current_user.is_author?
      @author_profile = current_user.find_profile(current_user.publisher.id)
    end 
  end
end
