class Questionnaire < ActiveRecord::Base
  attr_accessible :name, :description, :version, :publisher, :form_item_ids
  
  has_and_belongs_to_many :form_items, :order => "field_name"
  belongs_to :publisher
  has_many :responses
  
  validates_presence_of :name, :publisher
  
  def assemble_author_data
    questions = self.form_items
  end 
end
