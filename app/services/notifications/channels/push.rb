module Notifications
  module Channels
    class Push < ApplicationService
      def call(notification)
        send_push(notification)
      end

      private

      def send_push(notification)
        conn = Faraday.new(
          url: ENV.fetch('PUSH_API_BASE_URL', nil),
          headers: { 'Content-Type' => 'application/json' }
        )

        response = conn.post('/send') do |req|
          req.body = notification_params(notification).to_json
        end

        puts "Push notification sent! Response status: #{response.status}"
      end

      def notification_params(notification)
        {
          notification: {
            title: notification.title,
            content: notification.content,
            phone_number: notification.user.phone_number
          }
        }
      end
    end
  end
end
