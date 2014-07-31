class WelcomeController < ApplicationController
  
  def index
    if current_user && current_user.is_author?
      @author_profile = current_user.find_profile(current_user.publisher.id)
      if @author_profile.nil?
        redirect_to(new_author_path) and return
      end  
    end 
  end
end
