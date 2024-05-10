class RoomsController < ApplicationController
  include RenderConcern

  before_action :fetch_rooms, only: %i[index show]
  before_action :fetch_users, only: %i[index show]

  def index
    @room = Room.new
    render 'index'
  end

  def show
    @single_room = Room.find(params[:id])

    if @single_room.is_private && @single_room.users.exclude?(current_user)
      render_turbo_stream_with_flash('You are not a participant of this chat', :forbidden)
    else
      @room = Room.new
      @message = Message.new
      @messages = @single_room.messages.order(created_at: :asc)
      render 'index'
    end
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      head :ok
    else
      render_turbo_stream_with_flash(@room.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  private

  def fetch_rooms
    @rooms = Room.public_rooms
  end

  def fetch_users
    @users = User.all_except(current_user)
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
