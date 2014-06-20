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
  end
  
  def edit
    @form_item = FormItem.find(params[:id])
    @questionnaire_ids = Array.new
    FormItemsQuestionnaires.all(:conditions => {:form_item_id => @form_item.id}).collect{|fiq| @questionnaire_ids << fiq.questionnaire_id}
    unless @questionnaire_ids.nil?
      @questionnaires = Questionnaire.find(@questionnaire_ids)
      @q_links = ""
      @questionnaires.each do |q|
        @q_links = @q_links + "<a href='#{ROOT_URL}#{questionnaire_path(q)}'>#{q.name}</a><br />"
      end  
      flash[:notice] = "<p>Note these questionnaires are using this form item: <br />#{@q_links}</p>".html_safe
    end
  end
  
  def create
    unless params[:form_item][:publisher].nil?
      params[:form_item][:publisher] = Publisher.find(params[:form_item][:publisher])
    end  
    @form_item = FormItem.new(params[:form_item])
    respond_to do |format|
      if @form_item.save
        format.html { redirect_to form_items_url, notice: 'FormItem was successfully created.' }
        format.json { render json: @form_item, status: :created, form_item: @form_item }
      else
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
