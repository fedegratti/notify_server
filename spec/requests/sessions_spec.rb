# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Sessions' do
  let(:user_email) { 'johndoe@mail.com' }
  let(:user_password) { 'password123' }
  let!(:user) { create(:user, email: user_email, password: user_password, password_confirmation: user_password) }

  let(:valid_user_params) do
    {
      user: {
        email: user_email,
        password: user_password
      }
    }
  end

  let(:invalid_user_params) do
    {
      user: {
        email: 'nonexistent@mail.com',
        password: 'wrongpassword'
      }
    }
  end

  describe 'POST /login' do
    context 'with valid parameters' do
      it 'logs in an existing user' do
        post_json '/login', valid_user_params

        expect(response).to have_http_status(:ok)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Logged in successfully.')
        expect(json_response['status']['data']['user']['name']).to eq(user.name)
        expect(json_response['status']['data']['user']['email']).to eq(user_email)
        expect(json_response['status']['data']['user']).to have_key('id')
      end

      it 'does not return password in response' do
        post_json '/login', valid_user_params

        expect(json_response['status']['data']['user']).not_to have_key('password')
        expect(json_response['status']['data']['user']).not_to have_key('password_confirmation')
      end

      it 'returns authorization header' do
        post_json '/login', valid_user_params

        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to match(/Bearer .+/)
      end
    end

    context 'with invalid parameters' do
      it 'returns unauthorized for non-existent user' do
        post_json '/login', invalid_user_params

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized for wrong password' do
        wrong_password_params = {
          user: {
            email: user_email,
            password: 'wrongpassword'
          }
        }

        post_json '/login', wrong_password_params

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized for invalid email format' do
        invalid_email_params = {
          user: {
            email: 'invalid-email',
            password: 'password123'
          }
        }

        post_json '/login', invalid_email_params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with missing parameters' do
      it 'returns unauthorized when email is missing' do
        params = {
          user: {
            password: 'password123'
          }
        }

        post_json '/login', params

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized when password is missing' do
        params = {
          user: {
            email: user_email
          }
        }

        post_json '/login', params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /logout' do
    context 'with valid JWT token' do
      it 'logs out successfully' do
        # First login to get the token
        post_json '/login', valid_user_params
        auth_header = response.headers['Authorization']

        # Then logout with the token
        delete '/logout', headers: { 'Authorization' => auth_header }

        expect(response).to have_http_status(:ok)
        expect(json_response['status']).to eq(200)
        expect(json_response['message']).to eq('Logged out successfully.')
      end
    end

    context 'without authorization header' do
      it 'returns unauthorized' do
        delete '/logout'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['status']).to eq(401)
        expect(json_response['message']).to eq("Couldn't find an active session.")
      end
    end
  end
end
