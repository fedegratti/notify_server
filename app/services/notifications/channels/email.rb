# frozen_string_literal: true

module Notifications
  module Channels
    class Email < ApplicationService
      def call(notification)
        # Logic to send email notification
        puts "Sending email notification: #{notification.content}"
      end
    end
  end
end
