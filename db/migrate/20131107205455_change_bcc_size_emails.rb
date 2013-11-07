class ChangeBccSizeEmails < ActiveRecord::Migration
  def up
    change_column :emails, :bcc, :text
  end

  def down
    change_column :emails, :bcc, :string
  end
end
