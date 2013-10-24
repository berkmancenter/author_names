class Questionnaire < ActiveRecord::Base
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  attr_accessible :name, :description, :version, :publisher, :form_item_ids
  
  has_and_belongs_to_many :form_items, :order => "field_name"
  belongs_to :publisher
  has_many :responses
  
  validates_presence_of :name, :publisher
  
  def assemble_author_data
    questions = self.form_items
  end 
  
  def send_questionnaire_email(emails)
    # send to selected authors with link to questionnaire
    Email.create(
      :from => DEFAULT_MAILER_SENDER,
      :reply_to => DEFAULT_MAILER_SENDER,
      :to => DEFAULT_MAILER_SENDER,
      :bcc => emails.collect{|e| e.strip + ","},
      :subject => "[Author Names] Please Fill Out This Questionnaire",
      :body => "<p>Please <a href='#{ROOT_URL}#{questionnaire_path(self)}'>complete</a> this questionniare.</p>"
    )   
  end  
end
