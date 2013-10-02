class FormItemsQuestionnaires < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :form_item
  belongs_to :questionnaire
end
