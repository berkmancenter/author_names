class Questionnaire < ActiveRecord::Base
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  attr_accessible :name, :description, :version, :publisher, :form_item_ids
  
  has_and_belongs_to_many :form_items, :order => "form_item_position"
  belongs_to :publisher
  has_many :responses
  
  validates_presence_of :name, :publisher
  
  def assemble_author_data
    questions = self.form_items
  end 
  
  def send_questionnaire_email(emails)
    # send to selected authors with link to questionnaire
    Email.create(
      :from => self.publisher.email,
      :reply_to => self.publisher.email,
      :to => self.publisher.email,
      :bcc => emails.join(", "),
      :subject => "[Author Names] Please Fill Out This Questionnaire",
      :body => "<p>Please <a href='#{ROOT_URL}#{questionnaire_path(self)}'>complete</a> this questionniare.</p>"
    )   
  end  
  
  def send_new_author_questionnaire_email(emails)
    # send to selected authors with link to questionnaire
    Email.create(
      :from => self.publisher.email,
      :reply_to => self.publisher.email,
      :to => self.publisher.email,
      :bcc => emails.join(", "),
      :subject => "[Author Names] Please Fill Out This Questionnaire",
      :body => "<p>Please <a href='#{ROOT_URL}#{new_user_registration_path(:publisher_id => self.publisher.id, :a => true)}'>create</a> an account and <a href='#{ROOT_URL}#{questionnaire_path(self)}'>complete</a> this questionniare.</p>"
    )   
  end  
end
