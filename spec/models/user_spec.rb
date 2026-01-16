require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'factory' do
    it 'creates a valid user' do
      user = create(:user)
      expect(user).to be_persisted
      expect(user.name).to be_present
      expect(user.email).to be_present
    end

    it 'creates users with unique emails using trait' do
      user1 = create(:user, :with_unique_email)
      user2 = create(:user, :with_unique_email)
      expect(user1.email).not_to eq(user2.email)
    end
  end
end
