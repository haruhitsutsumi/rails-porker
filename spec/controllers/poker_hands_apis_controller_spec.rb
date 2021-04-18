# ポーカーapiのコントローラーのテストクラス
require 'rails_helper'
require './app/controllers/api/poker_hands_apis_controller'
require "json"

RSpec.describe Api::PokerHandsApisController do
  describe 'Post #judge' do
    before do
      post :judge, params: {"cards":["H1 H2 H3 H4 H5","H1 C1 S1 H2 C2"]}
    end
    example 'ステータスが200であること' do
      expect(response.status).to eq 200
    end
    example 'jsonが返されてること。一つ目の役がストレート・フラッシュであること' do
      expect(JSON.parse(response.body)["result"][0]["hand"]).to eq 'ストレート・フラッシュ'
    end
  end
end
