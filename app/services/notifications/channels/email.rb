# frozen_string_literal: true

module Notifications
  module Channels
    class Email < ApplicationService
      def call(notification)
        send_email(notification)
      end

      private

      def send_email(notification)
        conn = Faraday.new(
          url: ENV.fetch('EMAIL_API_BASE_URL', nil),
          headers: { 'Content-Type' => 'application/json' }
        )

        response = conn.post('/send') do |req|
          req.body = notification_params(notification).to_json
        end

        puts "Email sent! Response status: #{response.status}"
      end

      def notification_params(notification)
        {
          notification: {
            title: notification.title,
            content: notification.content,
            email: notification.user.email
          }
        }
      end
    end
  end
end
