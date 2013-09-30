class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :questionnaire, :null => false
      t.references :user, :null => false
      t.references :form_item, :null => false
      t.text :response_text
      t.timestamps
    end
  end
end
