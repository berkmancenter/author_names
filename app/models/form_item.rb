class FormItem < ActiveRecord::Base
  attr_accessible :field_name, :display_text, :field_type, :field_options, :required
  
  has_and_belongs_to_many :questionnaires
end
