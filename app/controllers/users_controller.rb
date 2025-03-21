class UsersController < ApplicationController
  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end

  def show_current_user
    render json: @current_user
  end

  def show
    user = User.find(params[:id])
    render json: user, serializer: UserSerializer
  end

  def friends
    user = User.find(params[:id])
    friends = user.friends
    render json: friends, each_serializer: UserSerializer, status: :ok
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { message: "User updated successfully.", user: UserSerializer.new(user) }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :username, :email, :phone, :profile_picture, :profile_picture_url)
  end
end