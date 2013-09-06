class FormItemsController < ApplicationController
  
  def index
    @form_items = FormItem.paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @form_item = FormItem.new
  end
  
  def edit
    @form_item = FormItem.find(params[:id])
  end
  
  def create
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
end
