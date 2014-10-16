class FormItemGroupsQuestionnaires < ActiveRecord::Migration
  def change
    create_table(:form_item_groups_questionnaires) do|t|
      t.references :form_item_group
      t.references :questionnaire
    end
  end
end
