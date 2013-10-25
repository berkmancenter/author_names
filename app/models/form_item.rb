class FormItem < ActiveRecord::Base
  attr_accessible :field_name, :display_text, :field_type, :field_options, :required, :publisher
  
  has_and_belongs_to_many :questionnaires
  belongs_to :publisher
  
  validates_presence_of :field_name, :field_type
  validates_uniqueness_of :field_name
  validates_format_of :field_name, :with => /^\S+\w{2,32}\S{1,}/, :message => "cannot contain spaces or special characters"
  
  FIELD_TYPES = ['Checkbox', 'Dropdown', 'File', 'Radio', 'String', 'Textarea', 'Date', 'Label' ]
  FIELD_OPTIONS = ['']
  
  def to_s
    self.field_name
  end  
  
  def formtastic_field_map
    as_param = ""
    
    if self.field_type == "Checkbox"
      as_param = "check_boxes"  
    elsif self.field_type == "Dropdown"
      as_param = "select"
    elsif self.field_type == "File"
      as_param = "file"
    elsif self.field_type == "Radio"
      as_param = "radio"
    elsif self.field_type == "String"
      as_param = "string"
    elsif self.field_type == "Textarea"
      as_param = "text"
    elsif self.field_type == "Date"
      as_param = "date_select"  
    end            
  end 
end
