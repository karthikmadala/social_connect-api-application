class CreateFriendRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :friend_requests do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.integer "status", default: "pending", null: false
      t.timestamps
    end
  end
end
