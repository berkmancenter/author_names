class AddLogoPublishers < ActiveRecord::Migration
  def up
    add_column :publishers, :logo, :string
  end

  def down
    remove_column :publishers, :logo
  end
end
