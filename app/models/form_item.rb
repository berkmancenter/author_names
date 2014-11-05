class FormItem < ActiveRecord::Base
  attr_accessible :field_name, :display_text, :field_type, :field_options, :required, :publisher, :form_item_group
  
  has_and_belongs_to_many :questionnaires
  belongs_to :publisher
  belongs_to :form_item_group
  has_many :responses
  
  accepts_nested_attributes_for :form_item_group
  
  validates_presence_of :field_name, :field_type
  validates_uniqueness_of :field_name
  validates_format_of :field_name, :with => /^\S+\w{2,32}\S{1,}/, :message => "cannot contain spaces or special characters"
  
  FIELD_TYPES = ['Checkbox', 'Dropdown', 'File', 'Radio', 'String', 'Textarea', 'Date', 'Label' ]
  FIELD_OPTIONS = ['']
  AUTHOR_INFO = ['creator_given_name', 'creator_surname', 'author_email', 'home_phone', 'home_address_1', 'home_address_2', 'home_address_city', 'home_address_state', 'home_address_postalcode', 'home_address_country']
  
  def to_s
    self.field_name
  end 
  
  def can_delete?
    a = true
    self.responses.each do |resp|
      if !resp.lib_exported_flag || !resp.pub_exported_flag
        a = false
        break
      end    
    end
    return a
  end 
  
  def self.admin_groups
    return FormItemGroup.where(:publisher_id => nil).pluck(:name).uniq
  end 
  
  def self.pub_groups(publisher)
    return FormItemGroup.where(:publisher_id => publisher).pluck(:name).uniq
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
  
  def author_profile_map(author)
    a = Author.find(author)
    if self.field_name == "creator_given_name"
      return a.first_name
    elsif self.field_name == "creator_surname"
      return a.last_name
    elsif self.field_name == "author_email"
      return a.email
    elsif self.field_name == "home_phone"
      return a.phone
    elsif self.field_name == "home_address_1"
      return a.address_1
    elsif self.field_name == "home_address_2"
      return a.address_2
    elsif self.field_name == "home_address_city"
      return a.city
    elsif self.field_name == "home_address_state"
      return a.state
    elsif self.field_name == "home_address_postalcode"
      return a.postal_code
    elsif self.field_name == "home_address_country"          
      return a.country
    end      
  end  
end