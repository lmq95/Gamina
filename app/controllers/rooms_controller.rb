class RoomsController < ApplicationController
  
  def create
    @room = Room.create
    @current_entry = Entry.create(user_id: current_user.id, room_id: @room.id)
    @another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: @room.id)
    redirect_to room_path(@room)
  end
  
  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      render request.referer
    end
  end
end
