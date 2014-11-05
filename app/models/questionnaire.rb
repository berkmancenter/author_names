class Questionnaire < ActiveRecord::Base
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  attr_accessible :name, :description, :version, :publisher, :form_item_ids, :form_item_group_ids
  
  has_and_belongs_to_many :form_items, :order => "form_items_questionnaires.position"
  belongs_to :publisher
  has_many :responses, :dependent => :destroy
  has_one :publication
  has_and_belongs_to_many :form_item_groups
  
  validates_presence_of :name, :publisher
  
  def assemble_author_data
    questions = self.form_items
  end 
  
  def send_questionnaire_email(email)
    # send to selected authors with link to questionnaire
    Email.create(
      :from => self.publisher.email,
      :reply_to => self.publisher.email,
      :to => email,
      :subject => "[Author Names] Please Fill Out This Questionnaire",
      :body => "<p>Welcome to OAQ, the Online Author Questionnaire system.</p>
                <p>Staff from #{self.publisher.name} have asked you to complete a questionnaire. This information will be used by #{self.publisher.name} to take advantage of your knowledge of your own work in order to best promote your book.</p>
                <p>Please <a href='#{ROOT_URL}#{questionnaire_path(self)}'>complete the questionnaire</a>. Having this information will help with promotion efforts, so completing the questionnaire in a timely fashion will be greatly appreciated.</p>
                <p>If you have any questions, please feel free to contact your editor.</p>
                <p>Thank you very much,<br />
                   #{self.publisher.name} staff</p>"
    )   
  end  
  
  def send_new_author_questionnaire_email(email)
    # send to selected authors with link to questionnaire
    Email.create(
      :from => self.publisher.email,
      :reply_to => self.publisher.email,
      :to => email,
      :subject => "[Author Names] Please Fill Out This Questionnaire",
      :body => "<p>Welcome to OAQ, the Online Author Questionnaire system.</p>
                <p>Staff from #{self.publisher.name} have asked you to complete a questionnaire. This information will be used by #{self.publisher.name} to take advantage of your knowledge of your own work in order to best promote your book.</p>
                <p>Please <a href='#{ROOT_URL}#{new_user_registration_path(:publisher_id => self.publisher.id, :a => true, :email => email)}'>create an account</a>, and then <a href='#{ROOT_URL}#{questionnaire_path(self)}'>complete the questionnaire</a>. Having this information will help with promotion efforts, so completing the questionnaire in a timely fashion will be greatly appreciated.</p>
                <p>If you have any questions, please feel free to contact your editor.</p>
                <p>Thank you very much,<br />
                   #{self.publisher.name} staff</p>"
    )   
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
end
