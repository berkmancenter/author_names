class FormItemsQuestionnaires < ActiveRecord::Base
  attr_accessible :position
  
  belongs_to :form_item
  belongs_to :questionnaire
end
