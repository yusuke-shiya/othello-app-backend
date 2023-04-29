require 'rails_helper'

RSpec.describe 'BattleRooms', type: :request do
  describe 'POST /api/v1/battle_rooms' do
    it 'バトルルームが作成され、作成されたバトルルームのIDがレスポンスとして返る' do
      post '/api/v1/battle_rooms'
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to be_present
    end
  end
end
