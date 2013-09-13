class Questionnaire < ActiveRecord::Base
  attr_accessible :name, :description, :version, :publisher, :form_item_ids
  
  has_and_belongs_to_many :form_items
  belongs_to :publisher
  
  validates_presence_of :name, :publisher
end
