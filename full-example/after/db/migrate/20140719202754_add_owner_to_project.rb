class AddOwnerToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :owner_id, :integer
  end
end
