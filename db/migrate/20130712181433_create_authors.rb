class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :phone, :null => false
      t.string :address_1, :limit => 150, :null => false
      t.string :address_2, :limit => 150
      t.string :city, :limit => 100, :null => false
      t.string :state, :limit => 100, :null => false
      t.string :postal_code, :limit => 30, :null => false
      t.string :country, :null => false
      t.references :publisher
      t.references :user
      t.timestamps
    end
  end
end
