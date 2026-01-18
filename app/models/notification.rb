# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user

  enum :channel, { email: 0, sms: 1, push: 2 }

  validates :title, presence: true
  validates :content, presence: true
  validates :channel, presence: true
end
