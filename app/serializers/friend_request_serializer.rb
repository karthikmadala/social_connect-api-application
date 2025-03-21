class FriendRequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :created_at, :sender_name, :receiver_name

  # Changed `sender` to `user` to match the model
  def sender_name
    object.user.username
  end

  # Changed `receiver` to `friend` to match the model
  def receiver_name
    object.friend.username
  end
end