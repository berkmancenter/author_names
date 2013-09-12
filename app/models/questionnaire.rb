class Questionnaire < ActiveRecord::Base
  attr_accessible :name, :description, :version, :publisher_id
  
  has_and_belongs_to_many :form_items
  belongs_to :publisher
end
