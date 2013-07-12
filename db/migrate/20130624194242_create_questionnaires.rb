class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.string :name
      t.text :description
      t.string :version
      t.references :publisher
      t.timestamps
    end
  end
end
