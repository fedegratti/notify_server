# frozen_string_literal: true

module Notifications
  class Send < ApplicationService
    def call(notification)
      services = Hash.new do |hash, key|
        hash[key] = "Notifications::Channels::#{key.to_s.capitalize}".constantize.new
      end

      services[notification.channel].call(notification)
    end
  end
end
