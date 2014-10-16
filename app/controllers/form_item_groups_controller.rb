class FormItemGroupsController < ApplicationController
  before_filter :authenticate_user!
  
  def destroy
    @form_item_group = FormItemGroup.find(params[:id])
    @form_item_group.form_items.each do |fi|
      fi.form_item_group_id = nil
      fi.save
    end  
    
    
    @form_item_group.questionnaires.each do |q|
      q.form_items = q.form_items - @form_item_group.form_items
      q.save
    end  
    @form_item_group.destroy

    respond_to do |format|
      format.html { redirect_to form_items_url, notice: 'Form Item Group was successfully deleted.' }
      format.json { head :no_content }
    end
  end 
end
