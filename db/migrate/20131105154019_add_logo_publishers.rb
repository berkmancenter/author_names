class AddLogoPublishers < ActiveRecord::Migration
  def up
    add_column :publishers, :logo, :string
  end

  def down
    remove_column :publishers, :string
  end
end
