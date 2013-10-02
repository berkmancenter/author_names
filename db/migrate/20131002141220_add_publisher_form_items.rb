class AddPublisherFormItems < ActiveRecord::Migration
  def up
    add_column :form_items, :publisher_id, :integer
  end

  def down
    remove_column :form_items, :publisher_id
  end
  
end
