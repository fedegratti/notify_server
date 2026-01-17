require 'rails_helper'

RSpec.describe "/notifications", type: :request do
  let!(:user) { create(:user) }
  let(:login_params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end
  
  let(:auth_headers) do
    post_json "/login", login_params
    { "Authorization" => response.headers["Authorization"] }
  end

  let(:valid_attributes) do
    {
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph,
      channel: Notification.channels.keys.sample,
      user_id: user.id
    }
  end

  let(:invalid_attributes) {
    {
      title: "", # Invalid: empty title
      content: Faker::Lorem.paragraph,
      channel: Notification.channels.keys.sample,
      user_id: user.id
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Notification.create! valid_attributes
      get notifications_url, headers: auth_headers, as: :json
      expect(response).to be_successful
    end

    it "returns unauthorized without authentication" do
      get notifications_url, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      notification = Notification.create! valid_attributes
      get notification_url(notification), headers: auth_headers, as: :json
      expect(response).to be_successful
    end

    it "returns unauthorized without authentication" do
      notification = Notification.create! valid_attributes
      get notification_url(notification), as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Notification" do
        expect {
          post notifications_url,
               params: { notification: valid_attributes }, headers: auth_headers, as: :json
        }.to change(Notification, :count).by(1)
      end

      it "renders a JSON response with the new notification" do
        post notifications_url,
             params: { notification: valid_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Notification" do
        expect {
          post notifications_url,
               params: { notification: invalid_attributes }, headers: auth_headers, as: :json
        }.to change(Notification, :count).by(0)
      end

      it "renders a JSON response with errors for the new notification" do
        post notifications_url,
             params: { notification: invalid_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "without authentication" do
      it "returns unauthorized" do
        post notifications_url,
             params: { notification: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          title: Faker::Lorem.sentence,
          content: Faker::Lorem.paragraph,
          channel: Notification.channels.keys.sample,
          user_id: user.id
        }
      end

      it "updates the requested notification" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification),
              params: { notification: new_attributes }, headers: auth_headers, as: :json
        notification.reload

        expect(notification.title).to eq(new_attributes[:title])
        expect(notification.content).to eq(new_attributes[:content])
        expect(notification.channel).to eq(new_attributes[:channel])
        expect(notification.user_id).to eq(new_attributes[:user_id])
      end

      it "renders a JSON response with the notification" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification),
              params: { notification: new_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the notification" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification),
              params: { notification: invalid_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "without authentication" do
      it "returns unauthorized" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification),
              params: { notification: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested notification" do
      notification = Notification.create! valid_attributes
      expect {
        delete notification_url(notification), headers: auth_headers, as: :json
      }.to change(Notification, :count).by(-1)
    end

    it "returns unauthorized without authentication" do
      notification = Notification.create! valid_attributes
      delete notification_url(notification), as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
