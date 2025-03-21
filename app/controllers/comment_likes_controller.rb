class CommentLikesController < ApplicationController
  before_action :authorize_request
  before_action :set_comment

  def create
    like = @comment.comment_likes.build(user: @current_user)
    if like.save
      render json: { message: "Comment liked successfully." }, status: :created
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    like = @comment.comment_likes.find_by(user: @current_user)
    if like
      like.destroy
      render json: { message: "Comment unliked successfully." }
    else
      render json: { error: "Like not found." }, status: :not_found
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
