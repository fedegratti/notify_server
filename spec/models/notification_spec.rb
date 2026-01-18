# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph,
      channel: described_class.channels.keys.sample,
      user: user
    }
  end

  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        notification = described_class.new(valid_attributes)

        expect(notification).to be_valid
      end
    end

    context 'title validation' do
      it 'is invalid without a title' do
        notification = described_class.new(valid_attributes.except(:title))

        expect(notification).not_to be_valid
        expect(notification.errors[:title]).to include("can't be blank")
      end

      it 'is invalid with a blank title' do
        notification = described_class.new(valid_attributes.merge(title: ''))

        expect(notification).not_to be_valid
        expect(notification.errors[:title]).to include("can't be blank")
      end

      it 'is valid with a title' do
        notification = described_class.new(valid_attributes)

        expect(notification).to be_valid
      end
    end

    context 'content validation' do
      it 'is invalid without content' do
        notification = described_class.new(valid_attributes.except(:content))

        expect(notification).not_to be_valid
        expect(notification.errors[:content]).to include("can't be blank")
      end

      it 'is invalid with blank content' do
        notification = described_class.new(valid_attributes.merge(content: ''))

        expect(notification).not_to be_valid
        expect(notification.errors[:content]).to include("can't be blank")
      end

      it 'is valid with content' do
        notification = described_class.new(valid_attributes)

        expect(notification).to be_valid
      end
    end

    context 'channel validation' do
      it 'is valid with a valid channel' do
        notification = described_class.new(valid_attributes.merge(channel: described_class.channels.keys.sample))

        expect(notification).to be_valid
      end
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'is invalid without a user' do
      notification = described_class.new(valid_attributes.except(:user))
      expect(notification).not_to be_valid
      expect(notification.errors[:user]).to include('must exist')
    end

    it 'is valid with a user' do
      notification = described_class.new(valid_attributes)
      expect(notification).to be_valid
    end
  end

  describe 'enums' do
    it 'defines channel enum' do
      expect(described_class.channels).to eq({
                                               'email' => 0,
                                               'sms' => 1,
                                               'push' => 2
                                             })
    end

    it 'can be created with email channel' do
      notification = create(:notification, channel: :email)
      expect(notification.channel).to eq('email')
      expect(notification.email?).to be true
    end

    it 'can be created with sms channel' do
      notification = create(:notification, channel: :sms)
      expect(notification.channel).to eq('sms')
      expect(notification.sms?).to be true
    end

    it 'can be created with push channel' do
      notification = create(:notification, channel: :push)
      expect(notification.channel).to eq('push')
      expect(notification.push?).to be true
    end

    it 'provides query methods for each channel' do
      email_notification = create(:notification, channel: :email)
      sms_notification = create(:notification, channel: :sms)
      push_notification = create(:notification, channel: :push)

      expect(email_notification.email?).to be true
      expect(email_notification.sms?).to be false
      expect(email_notification.push?).to be false

      expect(sms_notification.email?).to be false
      expect(sms_notification.sms?).to be true
      expect(sms_notification.push?).to be false

      expect(push_notification.email?).to be false
      expect(push_notification.sms?).to be false
      expect(push_notification.push?).to be true
    end
  end

  describe 'factory' do
    it 'creates a valid notification' do
      notification = create(:notification)
      expect(notification).to be_valid
      expect(notification.title).to be_present
      expect(notification.content).to be_present
      expect(notification.channel).to be_present
      expect(notification.user).to be_present
    end

    it 'creates a notification with associations' do
      notification = create(:notification)
      expect(notification.user).to be_a(User)
      expect(notification.user).to be_persisted
    end
  end

  describe 'scopes and queries' do
    let!(:email_notifications) { create_list(:notification, 2, channel: :email) }
    let!(:sms_notifications) { create_list(:notification, 3, channel: :sms) }
    let!(:push_notifications) { create_list(:notification, 1, channel: :push) }

    it 'can filter by channel using enum scopes' do
      expect(described_class.email.count).to eq(2)
      expect(described_class.sms.count).to eq(3)
      expect(described_class.push.count).to eq(1)
    end
  end
end
