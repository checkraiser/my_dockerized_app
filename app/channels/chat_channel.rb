class ChatChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'ChatChannel: subscribed!'
    stream_from "chat_#{params[:room]}"
  end
end
