require 'rails_helper'

RSpec.describe "Resources", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/resources/index"
      expect(response).to have_http_status(:success)
    end
  end

end
