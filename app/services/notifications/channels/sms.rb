module Notifications
  module Channels
    class Sms < ApplicationService
      def call(notification)
        send_sms(notification)
      end

      private

      def send_sms(notification)
        conn = Faraday.new(
          url: ENV.fetch('SMS_API_BASE_URL', nil),
          headers: { 'Content-Type' => 'application/json' }
        )

        response = conn.post('/send') do |req|
          req.body = notification_params(notification).to_json
        end

        puts "SMS sent! Response status: #{response.status}"
      end

      def notification_params(notification)
        {
          notification: {
            title: notification.title,
            content: notification.content,
            phone_number: '+541234556789'
          }
        }
      end
    end
  end
end
