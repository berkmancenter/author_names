class FormItemsQuestionnaires < ActiveRecord::Base
  attr_accessible :form_item_position
  
  belongs_to :form_item
  belongs_to :questionnaire
end
