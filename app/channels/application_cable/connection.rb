module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :unique_id

    # グローバルなバトルルームの状態を保持するハッシュ
    @@room_states = {}

    def connect
      self.unique_id = SecureRandom.uuid
    end

    def room_states
      @@room_states
    end
  end
end
