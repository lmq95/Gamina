# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    current_entries = current_user.entries
    my_room_ids = []
    current_entries.each do |entry|
      my_room_ids << entry.room.id
    end
     @another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: current_user.id)
  end
  
  def create
    @room = Room.create
    @current_entry = Entry.create(user_id: current_user.id, room_id: @room.id)
    @another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: @room.id)
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages.page(params[:page]).per(8)
      @message = Message.new
      @entries = @room.entries
    else
      render request.referer
    end
  end
end
