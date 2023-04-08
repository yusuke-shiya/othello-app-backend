module Api
  module V1
    class MessagesController < ApplicationController
      def index
        messages = Message.order(created_at: :desc)
        render json: { status: 'SUCCESS', message: 'Loaded messages', data: messages }
      end
    end
  end
end
