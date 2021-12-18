class MessagesController < ApplicationController

  def create
    message = Message.new(messages_params)
    message.user_id = current_user.id
    if message.save
       redirect_to room_path(message.room)
    else
      render request.referer
    end
  end

  private
  def messages_params
    params.require(:message).permit(:room_id,:body)
  end
end
