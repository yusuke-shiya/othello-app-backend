class BattleRoomChannel < ApplicationCable::Channel
  def subscribed
    @room_id = params[:room_id]
    # ルームIDと手番を記録
    @player = {
      id: unique_id,
      color: room_states[@room_id]&.first&.[](:color) == 'black' ? 'white' : 'black'
    }
    return reject unless can_join_room?

    stream_from "battle_room_channel_#{@room_id}"

    # 接続したプレイヤーがどちらの手番かを送信
    transmit({ myColor: @player[:color] })
    # ルームの状態を更新
    update_room_state
    battle_status = room_states[@room_id].count == 2 ? 'playing' : 'waiting'
    ActionCable.server.broadcast("battle_room_channel_#{@room_id}",
                                 { battleStatus: battle_status })
  end

  def unsubscribed
    # クライアントが切断したらルームから削除
    room_states[@room_id]&.delete(@player)
  end

  def receive(data)
    ActionCable.server.broadcast("battle_room_channel_#{@room_id}", data)
  end

  private

  def room_states
    connection.room_states
  end

  def can_join_room?
    players = room_states[@room_id] || []
    players.count < 2
  end

  def update_room_state
    players = room_states[@room_id] || []
    players << @player
    logger.debug(players)
    room_states[@room_id] = players
  end
end
