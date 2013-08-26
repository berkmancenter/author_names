class CreateFormItems < ActiveRecord::Migration
  def change
    create_table :form_items do |t|
      t.string :field_name, :null => false
      t.string :display_text
      t.string :field_type, :null => false
      t.string :field_options
      t.boolean :required, :default => false
      t.timestamps
    end
    
    create_table(:form_items_questionnaires, :id => false) do|t|
      t.references :form_item
      t.references :questionnaire
      t.timestamps
    end
    
    [:field_name, :display_text, :field_type, :field_options].each do|col|
      add_index :form_items, col
    end
  end
end