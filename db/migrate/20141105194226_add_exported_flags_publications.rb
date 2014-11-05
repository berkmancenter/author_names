class AddExportedFlagsPublications < ActiveRecord::Migration
  def change
    add_column :publications, :lib_exported_flag, :boolean, :default => false
    add_column :publications, :pub_exported_flag, :boolean, :default => false
  end
end
