class FriendRequestsController < ApplicationController
  before_action :authorize_request  
  before_action :set_friend_request, only: [:accept, :reject, :cancel]

  def index
    requests = current_user.received_friend_requests.pending
    render json: requests, each_serializer: FriendRequestSerializer
  end

  def create
    friend = User.find_by(id: params[:friend_id])

    unless friend
      render json: { error: "User not found." }, status: :not_found
      return
    end

    if FriendRequest.between(current_user, friend).exists?
      render json: { error: "Friend request already sent or exists." }, status: :unprocessable_entity
      return
    end

    # Changed `receiver:` to `friend:` to match the model
    @friend_request = current_user.sent_friend_requests.build(friend: friend, status: "pending")

    if @friend_request.save
      render json: { message: "Friend request sent successfully." }, status: :ok
    else
      render json: { error: @friend_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept
    # Changed `accepted?` to direct status check
    if @friend_request.status == "accepted"
      render json: { error: "This request is already accepted." }, status: :unprocessable_entity
    elsif @friend_request.friend == current_user
      FriendRequest.transaction do
        @friend_request.update!(status: "accepted")
        # Use `user:` and `friend:` to match model; avoid duplicates
        FriendRequest.find_or_create_by(user: @friend_request.friend, friend: @friend_request.user) do |fr|
          fr.status = "accepted"
        end
      end
      render json: { message: "Friend request accepted successfully." }, status: :ok
    else
      render json: { error: "Unable to accept the friend request." }, status: :unprocessable_entity
    end
  end

  def reject
    if @friend_request.update(status: 'rejected')
      render json: { message: "Friend request rejected successfully." }, status: :ok
    else
      render json: { error: "Unable to reject the friend request." }, status: :unprocessable_entity
    end
  end

  def cancel
    if @friend_request.status == 'pending' && @friend_request.destroy
      render json: { message: "Friend request canceled successfully." }, status: :ok
    else
      render json: { error: "Unable to cancel the friend request." }, status: :unprocessable_entity
    end
  end

  def unfriend
    friend = User.find_by(id: params[:friend_id])

    unless friend
      render json: { error: "User not found." }, status: :not_found
      return
    end

    friend_requests = FriendRequest.between(current_user, friend)

    if friend_requests.any?
      friend_requests.destroy_all
      render json: { message: "Unfriended successfully." }, status: :ok
    else
      render json: { error: "No friend request found." }, status: :unprocessable_entity
    end
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find_by(id: params[:id])

    unless @friend_request && (@friend_request.user == current_user || @friend_request.friend == current_user)
      render json: { error: "Friend request not found." }, status: :not_found
    end
  end
end