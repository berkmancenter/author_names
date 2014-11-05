class Publication < ActiveRecord::Base
  attr_accessible :publisher_id, :questionnaire_id, :user_id, :author_id
  
  belongs_to :user
  belongs_to :author
  belongs_to :publisher
  belongs_to :questionnaire
  has_many :responses, :dependent => :destroy
end
