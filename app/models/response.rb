class Response < ActiveRecord::Base
  attr_accessible :user_id, :questionnaire_id, :form_item_id, :response_text
  
  belongs_to :user
  belongs_to :questionnaire
  belongs_to :form_item
end
