require 'rails_helper'

RSpec.describe '/', type: :request do
    describe "GET /" do
        it "returns a ok message" do
            get "/"
            
            expect(response).to have_http_status(:ok)
            expect(json_response["status"]).to eq("ok")
        end
    end
end