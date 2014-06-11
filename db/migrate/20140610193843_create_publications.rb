class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.references :user
      t.references :author
      t.references :publisher
      t.references :questionnaire
      t.timestamps
    end
  end
end
