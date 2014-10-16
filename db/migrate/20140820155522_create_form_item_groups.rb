class CreateFormItemGroups < ActiveRecord::Migration
  def change
    create_table :form_item_groups do |t|
      t.string :name
      t.references :publisher
      t.references :questionnaire
      t.timestamps
    end
  end
end
