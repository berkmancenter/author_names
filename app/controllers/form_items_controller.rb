class FormItemsController < ApplicationController
  
  def index
    @form_items = FormItem.find(:all, :conditions => {:publisher_id => nil})
    #@form_items = FormItem.paginate(:page => params[:page], :per_page => 10)
    if current_user.is_pub_admin?
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
      format.html { redirect_to form_items_url }
      format.json { head :no_content }
    end
  end 
  
  def view_field
    @form_item = FormItem.find(params[:id])
  end  
end
