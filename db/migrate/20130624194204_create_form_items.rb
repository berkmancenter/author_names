class CreateFormItems < ActiveRecord::Migration
  def change
    create_table :form_items do |t|
      
      t.timestamps
    end
    
    create_table(:form_items_questionnaires, :id => false) do|t|
      t.references :form_item
      t.references :questionnaire
    end
  end
end
