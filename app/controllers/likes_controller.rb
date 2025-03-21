class LikesController < ApplicationController
  before_action :authorize_request
  before_action :set_post

  def create
    like = @post.likes.build(user: @current_user)
    if like.save
      render json: { message: "Post liked successfully." }, status: :created
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    like = @post.likes.find_by(user: @current_user)
    if like
      like.destroy
      render json: { message: "Like removed successfully." }
    else
      render json: { error: "Like not found." }, status: :not_found
    end
  end

  def liked_users
    users = @post.liked_users
    render json: users, status: :ok
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
