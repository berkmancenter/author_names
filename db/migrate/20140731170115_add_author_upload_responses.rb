class AddAuthorUploadResponses < ActiveRecord::Migration
  def change
    add_column :responses, :author_upload, :string
  end
end
