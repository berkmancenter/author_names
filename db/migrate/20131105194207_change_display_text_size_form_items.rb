class ChangeDisplayTextSizeFormItems < ActiveRecord::Migration
  def up
    change_column :form_items, :display_text, :text
  end

  def down
    change_column :form_items, :display_text, :string
  end
end
