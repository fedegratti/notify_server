module Notifications
  module Channels
    class Push < ApplicationService
      def call(notification)
        # Logic to send push notification
        puts "Sending push notification: #{notification.content}"
      end
    end
  end
end
