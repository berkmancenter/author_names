class RemoveLimitCountryLibraries < ActiveRecord::Migration
  def up
    change_column :libraries, :country, :string, :null => false
  end

  def down
    change_column :libraries, :country, :string, :limit => 2, :null => false
  end
end
