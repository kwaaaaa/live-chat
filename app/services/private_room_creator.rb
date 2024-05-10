class PrivateRoomCreator
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
    @ids = [current_user.id, user.id].sort
  end

  def find_or_create
    Room.joins(:participants).where(participants: { user_id: @ids }).group(:id).having('count(room_id) = 2').take ||
      Room.create(name: create_name, is_private: true, users: [@current_user, @user])
  end

  private

  def create_name
    "private_#{@ids[0]}_#{@ids[1]}"
  end
end
