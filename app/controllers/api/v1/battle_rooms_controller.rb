module Api
  module V1
    class BattleRoomsController < ApplicationController
      def create
        battle_room = BattleRoom.new

        if battle_room.save
          render json: { id: battle_room.id }, status: :created
        else
          render json: { errors: battle_room.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
