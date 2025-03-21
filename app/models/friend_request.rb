class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, uniqueness: { scope: :friend_id, message: "Friend request already sent." }

  scope :pending, -> { where(status: "pending") }
  scope :between, ->(user1, user2) {
    where("(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)",
          user1.id, user2.id, user2.id, user1.id)
  }
end
