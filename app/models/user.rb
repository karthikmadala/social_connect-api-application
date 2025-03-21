class User < ApplicationRecord
  has_secure_password

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friend_requests, dependent: :destroy
  has_many :accepted_friend_requests, -> { where(status: "accepted") }, class_name: "FriendRequest"
  has_many :pending_friend_requests, -> { where(status: "pending") }, class_name: "FriendRequest"

  has_many :friends, -> { where(friend_requests: { status: "accepted" }) }, through: :friend_requests
  has_many :pending_friends, through: :pending_friend_requests, source: :friend

  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id"
  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "user_id"
  has_many :inverse_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id", dependent: :destroy


  has_one_attached :profile_picture

  validates :profile_picture, content_type: [ "image/png", "image/jpeg" ]

  after_commit :update_profile_picture_url, if: -> { profile_picture.attached? }

  def update_profile_picture_url
    if profile_picture.attached?
      update_column(:profile_picture_url, Rails.application.routes.url_helpers.rails_blob_url(profile_picture, only_path: true))
    end
  end  

  def friend_request_status(other_user)
    friend_request = friend_requests.find_by(friend_id: other_user.id)
    return "Friends" if friend_request&.status == "accepted"
    return "Pending" if friend_request&.status == "pending"
    "Add Friend"
  end
end
