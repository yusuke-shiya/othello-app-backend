class BattleRoomChannel < ApplicationCable::Channel
  def subscribed
    return reject unless can_join_room?

    stream_from "battle_room_channel_#{room_id}"

    # 接続したプレイヤーがどちらの手番かを送信
    transmit({ myColor: player[:color] })
    # ルームの状態を更新
    update_room_state
    ActionCable.server.broadcast("battle_room_channel_#{room_id}", room_states[room_id])
  end

  def unsubscribed
    # クライアントが切断したらルームから削除
    room_states[room_id][:players].delete(player)
  end

  def receive(data)
    room_states[room_id][:othello] = data
    ActionCable.server.broadcast("battle_room_channel_#{room_id}", room_states[room_id])
  end

  private

  def room_id
    @room_id ||= params[:room_id]
  end

  def player
    @player ||= {
      id: unique_id,
      color: current_players.first&.dig(:color) == 'black' ? 'white' : 'black'
    }
  end

  def room_states
    connection.room_states
  end

  def current_players
    room_states[room_id]&.dig(:players) || []
  end

  def can_join_room?
    current_players.count < 2
  end

  def update_room_state
    players = current_players
    players << player

    room_states[room_id] = {
      players: players,
      battleStatus: players.count == 2 ? 'playing' : 'waiting',
      othello: room_states[room_id]&.dig(:othello)
    }
  end
end
