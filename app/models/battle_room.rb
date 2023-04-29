class BattleRoom < ApplicationRecord
  before_create :set_initial_state

  private

  def set_initial_state
    self.board ||= Array.new(8) { Array.new(8, 'empty') }
    self.current_player ||= 'black'
  end
end
