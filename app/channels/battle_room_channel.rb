class BattleRoomChannel < ApplicationCable::Channel
  def subscribed
    @room_id = params[:room_id]
    stream_from "battle_room_channel_#{@room_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("battle_room_channel_#{@room_id}", data)
  end
end
