require 'rails_helper'

RSpec.describe "User Registrations", type: :request do
  let(:valid_user_params) do
    {
      user: {
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end

  let(:invalid_user_params) do
    {
      user: {
        name: "",
        email: "invalid-email",
        password: "123",
        password_confirmation: "456"
      }
    }
  end

  describe "POST /signup" do
    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post_json "/signup", valid_user_params
        }.to change(User, :count).by(1)
      end

      it "returns success response with user data" do
        post_json "/signup", valid_user_params
        
        expect(response).to have_http_status(:ok)
        expect(json_response["status"]["code"]).to eq(200)
        expect(json_response["status"]["message"]).to eq("Signed up successfully.")
        expect(json_response["data"]["name"]).to eq("John Doe")
        expect(json_response["data"]["email"]).to eq("john@example.com")
        expect(json_response["data"]).to have_key("id")
      end

      it "does not return password in response" do
        post_json "/signup", valid_user_params
        
        expect(json_response["data"]).not_to have_key("password")
        expect(json_response["data"]).not_to have_key("password_confirmation")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post_json "/signup", invalid_user_params
        }.not_to change(User, :count)
      end

      it "returns unprocessable_content status" do
        post_json "/signup", invalid_user_params
        
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns error messages" do
        post_json "/signup", invalid_user_params
        
        expect(json_response["status"]["message"]).to include("User couldn't be created successfully")
      end
    end

    context "with missing parameters" do
      it "handles missing name" do
        params = valid_user_params.deep_dup
        params[:user][:name] = ""
        
        post_json "/signup", params
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["status"]["message"]).to include("Name can't be blank")
      end

      it "handles invalid email format" do
        params = valid_user_params.deep_dup
        params[:user][:email] = "invalid-email"
        
        post_json "/signup", params
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["status"]["message"]).to include("Email is invalid")
      end

      it "handles password confirmation mismatch" do
        params = valid_user_params.deep_dup
        params[:user][:password_confirmation] = "different_password"
        
        post_json "/signup", params
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["status"]["message"]).to include("Password confirmation doesn't match Password")
      end
    end

    context "with duplicate email" do
      before do
        create(:user, email: "john@example.com")
      end

      it "does not create a new user" do
        expect {
          post_json "/signup", valid_user_params
        }.not_to change(User, :count)
      end

      it "returns error message about duplicate email" do
        post_json "/signup", valid_user_params
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["status"]["message"]).to include("Email has already been taken")
      end
    end
  end
end
