class MessagesController < ApplicationController
  include RenderConcern

  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      render 'create'
    else
      render_turbo_stream_with_flash(@message.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :content)
  end
end
