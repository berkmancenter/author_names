class Questionnaire < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_and_belongs_to_many :form_items
end
