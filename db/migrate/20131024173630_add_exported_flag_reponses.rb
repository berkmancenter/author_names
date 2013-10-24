class AddExportedFlagReponses < ActiveRecord::Migration
  def up
    add_column :responses, :exported_flag, :boolean, :default => false
  end

  def down
    remove_column :responses, :exported_flag
  end
end
