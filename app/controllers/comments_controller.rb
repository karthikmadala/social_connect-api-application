class CommentsController < ApplicationController
  before_action :authorize_request
  before_action :set_post

  def create
    comment = @post.comments.build(comment_params.merge(user: @current_user))
    if comment.save
      render json: { message: "Comment added successfully.", comment: CommentSerializer.new(comment) }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    comment = @post.comments.find(params[:id])
    if comment.user == @current_user
      if comment.update(comment_params)
        render json: { message: "Comment updated successfully.", comment: CommentSerializer.new(comment) }
      else
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unauthorized to update this comment." }, status: :unauthorized
    end
  end

  def destroy
    comment = @post.comments.find(params[:id])
    if comment.user == @current_user
      comment.destroy
      render json: { message: "Comment deleted successfully." }
    else
      render json: { error: "Unauthorized to delete this comment." }, status: :unauthorized
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
