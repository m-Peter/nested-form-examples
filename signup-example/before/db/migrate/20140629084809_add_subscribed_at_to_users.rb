class AddSubscribedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_at, :datetime
  end
end
