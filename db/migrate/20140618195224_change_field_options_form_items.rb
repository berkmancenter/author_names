class ChangeFieldOptionsFormItems < ActiveRecord::Migration
  def change
    change_column :form_items, :field_options, :text
  end
end
