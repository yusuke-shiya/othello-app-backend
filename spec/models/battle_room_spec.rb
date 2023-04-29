require 'rails_helper'

RSpec.describe BattleRoom, type: :model do
  describe 'before_create :set_initial_state' do
    let(:battle_room) { BattleRoom.new }

    it 'board が正しく初期化されている' do
      battle_room.save!
      expect(battle_room.board).to eq(Array.new(8) { Array.new(8, 'empty') })
    end

    it 'current_player が正しく初期化されている' do
      battle_room.save!
      expect(battle_room.current_player).to eq('black')
    end
  end
end
