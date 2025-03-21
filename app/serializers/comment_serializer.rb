class CommentSerializer < ActiveModel::Serializer
  attributes :user_id, :post_id, :id, :content, :created_at

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

end