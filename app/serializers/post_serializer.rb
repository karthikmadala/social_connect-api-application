class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :image_url, :updated_at, :likes_count, :comments_count, :liked_users, :comments

  def likes_count
    object.likes.size
  end

  def comments_count
    object.comments.size
  end

  def liked_users
    object.liked_users.pluck(:id, :username).map { |id, username| { id: id, username: username } }
  end

  def comments
    object.comments.includes(:user, :comment_likes).map do |comment|
      {
        id: comment.id,
        content: comment.content,
        user: { id: comment.user.id, username: comment.user.username },
        likes_count: comment.comment_likes.size,
        liked_users: comment.comment_likes.map { |like| { id: like.user.id, username: like.user.username } }
      }
    end
  end

  def image_url
    object.image_url.presence || (object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) : nil)
  rescue StandardError => e
    nil
  end
  # include Rails.application.routes.url_helpers

  # def image_url
  #   object.image.attached? ? rails_blob_url(object.image, only_path: true) : nil
  # end
end
