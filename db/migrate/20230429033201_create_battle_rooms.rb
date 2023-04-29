class CreateBattleRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :battle_rooms do |t|
      t.json :board
      t.string :current_player, null: false, default: 'black'

      t.timestamps
    end
  end
end
