class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end
end
