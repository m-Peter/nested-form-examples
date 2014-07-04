class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.integer :crew
      t.boolean :has_astromech
      t.integer :speed
      t.text :armament

      t.timestamps
    end

    add_index :ships, :name, { :name => "uix_ships_name", :unique => true }
  end
end
