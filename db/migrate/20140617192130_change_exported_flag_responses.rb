class ChangeExportedFlagResponses < ActiveRecord::Migration
  def change
    rename_column :responses, :exported_flag, :lib_exported_flag
    add_column :responses, :pub_exported_flag, :boolean, :default => false
    add_column :responses, :publication_id, :integer
  end
end
