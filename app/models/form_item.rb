class FormItem < ActiveRecord::Base
  attr_accessible :field_name, :display_text, :field_type, :field_options, :required
  
  has_and_belongs_to_many :questionnaires
  
  FIELD_TYPES = ['Checkbox', 'Dropdown', 'File', 'Radio', 'String', 'Textarea' ]
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
    end            
  end
  
  def form_tag_field_map
    as_param = ""
    
    if self.field_type == "Checkbox"
      as_param = "check_box_tag"  
    elsif self.field_type == "Dropdown"
      as_param = "select_tag"
    elsif self.field_type == "File"
      as_param = "file_field_tag"
    elsif self.field_type == "Radio"
      as_param = "radio_button_tag"
    elsif self.field_type == "String"
      as_param = "text_field_tag"
    elsif self.field_type == "Textarea"
      as_param = "text_area_tag"
    end            
  end  
end
