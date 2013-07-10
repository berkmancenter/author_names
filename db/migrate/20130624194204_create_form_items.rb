class CreateFormItems < ActiveRecord::Migration
  def change
    create_table :form_items do |t|

      t.timestamps
    end
  end
end
