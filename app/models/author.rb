class Author < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :publisher
  has_one :user
  
end
