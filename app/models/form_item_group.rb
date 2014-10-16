class FormItemGroup < ActiveRecord::Base
  attr_accessible :name, :publisher
  
  has_many :form_items#, :order => "form_items_questionnaires.position"
  belongs_to :publisher
  has_and_belongs_to_many :questionnaires
  
end
