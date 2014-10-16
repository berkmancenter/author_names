require 'csv'
class FormItemsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @form_items = FormItem.find(:all, :conditions => {:publisher_id => nil})
    if current_user.is_publisher?
      @your_form_items = FormItem.find(:all, :conditions => {:publisher_id => current_user.publisher.id})
    end  
  end
  
  def new
    unless params[:clone].nil?
      @form_item = FormItem.find(params[:clone]).dup
    else  
      @form_item = FormItem.new
    end  
    @form_item_group = @form_item.build_form_item_group
    if current_user.is_publisher?
      @pub_groups = FormItem.pub_groups(current_user.publisher.id)
    end  
  end
  
  def edit
    @form_item = FormItem.find(params[:id])
    @form_item_group = @form_item.build_form_item_group
    if current_user.is_publisher?
      @pub_groups = FormItemGroup.where(:publisher_id => current_user.publisher.id).pluck(:name).uniq
    end 
    @questionnaire_ids = Array.new
    FormItemsQuestionnaires.all(:conditions => {:form_item_id => @form_item.id}).collect{|fiq| @questionnaire_ids << fiq.questionnaire_id}
    unless @questionnaire_ids.nil?
      @questionnaires = Questionnaire.find(@questionnaire_ids)
      @q_links = ""
      @questionnaires.each do |q|
        @q_links = @q_links + "<a href='#{ROOT_URL}#{questionnaire_path(q)}'>#{q.name}</a><br />"
      end 
      unless @q_links.blank? 
        flash[:notice] = "<p>Note these questionnaires are using this form item: <br />#{@q_links}</p>".html_safe
      end  
    end
  end
  
  def create
    unless params[:form_item][:publisher].nil?
      params[:form_item][:publisher] = Publisher.find(params[:form_item][:publisher])
    end 
    if params[:form_item][:form_item_group].nil? || params[:form_item][:form_item_group][:name].blank?
      p "text field"
      if params[:new_group_name] == ""
        p "text field empty"
        params[:form_item] = params[:form_item].reject!{|key, value| key == "form_item_group" }  
      else  
        p "text field not empty"
        existing_group = FormItemGroup.find_by_name(params[:new_group_name])
        params[:form_item][:form_item_group] = existing_group.nil? ? FormItemGroup.create(:name => params[:new_group_name], :publisher => params[:form_item][:form_item_group][:publisher].blank? ? nil : Publisher.find(params[:form_item][:form_item_group][:publisher])) : existing_group
      end  
    else
      p "drop down"
      params[:form_item][:form_item_group][:publisher] = params[:form_item][:form_item_group][:publisher].blank? ? nil : Publisher.find(params[:form_item][:form_item_group][:publisher])
      params[:form_item][:form_item_group] = FormItemGroup.find_by_name(params[:form_item][:form_item_group][:name])  
    end 
    
    @form_item = FormItem.new(params[:form_item])
    respond_to do |format|
      if @form_item.save
        unless params[:form_item][:form_item_group].nil?
          params[:form_item][:form_item_group].save
        end  
        format.html { redirect_to form_items_url, notice: 'FormItem was successfully created.' }
        format.json { render json: @form_item, status: :created, form_item: @form_item }
      else
        @form_item_group = @form_item.build_form_item_group
        format.html { render action: "new" }
        format.json { render json: @form_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @form_item = FormItem.find(params[:id])
    unless params[:form_item][:publisher].nil?
      params[:form_item][:publisher] = Publisher.find(params[:form_item][:publisher])
    end 
    if params[:form_item][:form_item_group].nil? || params[:form_item][:form_item_group][:name].blank?
      p "text field"
      if params[:new_group_name] == ""
        p "text field empty"
        if params[:form_item][:form_item_group][:name] == ""
          @form_item.form_item_group = nil
        end
        params[:form_item] = params[:form_item].reject!{|key, value| key == "form_item_group" }  
      else  
        p "text field not empty"
        existing_group = FormItemGroup.find_by_name(params[:new_group_name])
        params[:form_item][:form_item_group] = existing_group.nil? ? FormItemGroup.create(:name => params[:new_group_name], :publisher => params[:form_item][:form_item_group][:publisher].blank? ? nil : Publisher.find(params[:form_item][:form_item_group][:publisher])) : existing_group
      end  
    else
      p "drop down"
      params[:form_item][:form_item_group][:publisher] = params[:form_item][:form_item_group][:publisher].blank? ? nil : Publisher.find(params[:form_item][:form_item_group][:publisher])
      params[:form_item][:form_item_group] = FormItemGroup.find_by_name(params[:form_item][:form_item_group][:name])  
    end 
    respond_to do |format|
      if @form_item.update_attributes(params[:form_item])
        format.html { redirect_to form_items_url, notice: 'FormItem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @form_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @form_item = FormItem.find(params[:id])
    @form_item.destroy

    respond_to do |format|
      format.html { redirect_to form_items_url, notice: 'Form Item was successfully deleted.' }
      format.json { head :no_content }
    end
  end 
  
  def destroy_all_items
    FormItem.destroy_all

    respond_to do |format|
      format.html { redirect_to batch_upload_form_items_url, notice: 'All Form Items were successfully deleted.' }
      format.json { head :no_content }
    end
  end 
  
  def view_field
    @form_item = FormItem.find(params[:id])
  end  
  
  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    CSV.parse(@file.read).each do |cell|
        
        asset={}
        
        asset[:field_name] = cell[0]
        asset[:display_text] = cell[1]
        asset[:field_type] = cell[2]
        asset[:field_options] = cell[3]
        asset[:required] = cell[4]
        
        @form_item = FormItem.new
 
        @form_item.attributes = asset
        @form_item.save
    end
    redirect_to form_items_path
  end 
end
