class CreatePilots < ActiveRecord::Migration
  def change
    create_table :pilots, force: true do |t|
      t.string :first_name
      t.string :last_name
      t.string :call_sign
      t.references :ship, index: true

      t.timestamps
    end

    add_index :pilots, :ship_id, { :name => "ix_pilots_ships" }
    add_index :pilots, :call_sign, { :name => "uix_pilots_call_sign", :unique => true }
  end
end
