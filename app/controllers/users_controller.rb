class UsersController < ApplicationController
  before_action :fetch_rooms, only: :show
  before_action :fetch_users, only: :show

  def show
    @user = User.find(params[:id])
    @room = Room.new
    @single_room = PrivateRoomCreator.new(current_user, @user).find_or_create
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'rooms/index'
  end

  private

  def fetch_rooms
    @rooms = Room.public_rooms
  end

  def fetch_users
    @users = User.all_except(current_user)
  end
end
