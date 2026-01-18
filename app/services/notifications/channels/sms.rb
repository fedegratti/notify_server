module Notifications
  module Channels
    class Sms < ApplicationService
      def call(notification)
        # Logic to send SMS notification
        puts "Sending SMS notification: #{notification.content}"
      end
    end
  end
end
