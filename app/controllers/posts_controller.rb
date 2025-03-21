class PostsController < ApplicationController
  before_action :authorize_request
  before_action :set_post, only: [ :show, :update, :destroy ]

  def index
    posts = Post.all
    render json: posts, each_serializer: PostSerializer
  end

  def show
    render json: @post, serializer: PostSerializer
  end

  def create
    post = @current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      render json: { message: "Post deleted successfully." }
      # head :no_content
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
