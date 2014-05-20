class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|
      t.string :name, :null => false
      t.text :description
      t.string :contact_name, :null => false
      t.string :phone, :null => false
      t.string :email, :null => false
      t.string :address_1, :limit => 150, :null => false
      t.string :address_2, :limit => 150
      t.string :city, :limit => 100, :null => false
      t.string :state, :limit => 100, :null => false
      t.string :postal_code, :limit => 30, :null => false
      t.string :country, :null => false
      t.string :website
      t.string :logo
      t.timestamps
    end
  end
end
