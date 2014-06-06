class QuestionnairesController < ApplicationController
  before_filter :authenticate_user!
  
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
    unless params[:author_user_id].nil?
      @user = User.find(params[:author_user_id])
    else
      @user = current_user  
    end  
    
    profile = Author.first(:conditions => {:email => @user.email, :publisher_id => @questionnaire.publisher.id})
    unless profile.nil?
      profile.user_id = @user.id
      profile.save
      @user.publisher_id = @questionnaire.publisher.id
      @user.save
    end 
    
    unless params[:gather_response].nil?
      redirect_to gather_response_questionnaires_url(:answers => params[:gather_response])
    end  
    
  end
  
  def new
    @questionnaire = Questionnaire.new
    
    @lib_req = FormItem.all(:conditions => {:publisher_id => nil, :required => true})
    @pub_req = FormItem.all(:conditions => {:publisher_id => current_user.publisher.id, :required => true})
  end
  
  def edit
    @questionnaire = Questionnaire.find(params[:id])
    
    @lib_req = FormItem.all(:conditions => {:publisher_id => nil, :required => true})
    @pub_req = FormItem.all(:conditions => {:publisher_id => current_user.publisher.id, :required => true})
    
    unless params[:sort_items].nil?
      redirect_to sort_items_questionnaires_url(:sort_items => params[:sort_items], :id => params[:id])
    end
  end
  
  def create
    params[:questionnaire][:publisher] = Publisher.find_by_name(params[:questionnaire][:publisher])
    
    params[:questionnaire][:form_item_ids] << FormItem.all(:conditions => {:required => true}).collect{|fi| fi.id.to_s}
    params[:questionnaire][:form_item_ids] = params[:questionnaire][:form_item_ids].flatten!.reject(&:empty?).collect{|fi| fi.to_i}
    
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
    
    params[:questionnaire][:form_item_ids] << FormItem.all(:conditions => {:required => true}).collect{|fi| fi.id.to_s}
    params[:questionnaire][:form_item_ids] = params[:questionnaire][:form_item_ids].flatten!.reject(&:empty?).collect{|fi| fi.to_i}
    
    respond_to do |format|
      if @questionnaire.update_attributes(params[:questionnaire])
        format.html { redirect_to edit_questionnaire_url(@questionnaire.id), notice: 'Questionnaire was successfully updated.' }
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
      format.html { redirect_to questionnaires_url, notice: 'Questionnaire was successfully deleted.' }
      format.json { head :no_content }
    end
  end  
  
  def gather_response
    params[:answers].each_value do |value|
      if FormItem.find(value["form_item_id"].to_i).field_type == "Date"
        value['response_text'] = Date.new(value['response_text(1i)'].to_i, value['response_text(2i)'].to_i, value['response_text(3i)'].to_i).to_s
        value.delete('response_text(1i)')
        value.delete('response_text(2i)')
        value.delete('response_text(3i)')
      end
      response = Response.create(value)
    end  
    
    redirect_to root_url, notice: 'Response was successfully recorded.'
  end  
  
  def choose_authors
    @questionnaire = Questionnaire.find(params[:questionnaire_id].to_i)
    @authors = current_user.my_authors
  end
  
  def send_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id].to_i)
    @authors = Array.new
    unless params[:emails].nil?
      @authors = params[:emails]
    end  
    unless params[:more_emails].blank?
      @new_authors = params[:more_emails].split(",").each{|e| e.strip!}
      # emails = Array.new
#       emails << params[:more_emails].split(",").each{|e| e.strip!}
#       emails.flatten!
#       emails.each do |email|
#         author = Author.new(:email => email, :publisher_id => params[:publisher_id])
#         author.first_name = ""
#         author.last_name = ""
#         author.phone = ""
#         author.address_1 = ""
#         author.city = ""
#         author.state = ""
#         author.postal_code = ""
#         author.country = ""
#         author.save
#       end
      # @authors << emails
      # @authors.flatten!
    end 
    respond_to do |format|
      unless params[:emails].nil? && params[:more_emails].blank?
        unless params[:emails].nil?
          @questionnaire.send_questionnaire_email(@authors.collect{|e| e.strip})
        end
        unless params[:more_emails].blank?
          @questionnaire.send_new_author_questionnaire_email(@new_authors.collect{|e| e.strip})
        end 
        format.html { redirect_to questionnaires_url, notice: 'Questionnaire was successfully sent.' }
        format.json { head :no_content }
      else
        format.html { redirect_to choose_authors_questionnaires_path(:questionnaire_id => @questionnaire), notice: 'Please select authors.' }
        format.json { head :no_content }
      end
    end
  end
  
  def sort_items
    @sorted_hash = params[:sort_items]
    
    @sorted_hash.each_key do |field_name|
      item = FormItem.first(:conditions => {:field_name => field_name})
      form_item_q = FormItemsQuestionnaires.first(:conditions => {:form_item_id => item.id, :questionnaire_id => params[:id] })

      FormItemsQuestionnaires.update_all(["form_item_position = ?", @sorted_hash[field_name].to_i], ["form_item_id = ? AND questionnaire_id = ?", item.id, params[:id].to_i])

      form_item_q.save
    end
    
    redirect_to edit_questionnaire_url(params[:id]), notice: 'Items sorted.'
  end
end
