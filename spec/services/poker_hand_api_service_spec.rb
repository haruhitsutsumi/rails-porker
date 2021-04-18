# ポーカーapiのサービス層のテストクラス
require 'rails_helper'
require './app/services/api/poker_hand_api_service'

RSpec.describe 'Service層のテスト' do
  describe 'judge' do
    before do
      @request = ["H1 H2 H3 H4 H5","H1 C1 S1 H2 C2"]
      @cards = PokerHandApiService.new(@request)
    end
    context '正常系確認' do
      example '一つ目の手札の一番強い手札のbest判定がtrueになっており、それ以外がfalseになってること' do
        expect(@cards.strength_judge[:result][0][:best]).to eq true
        expect(@cards.strength_judge[:result][1][:best]).to eq false
      end
    end
    context '正常系確認' do
      example '@responseの全てのcardが入力値と等しいこと' do
        expect(@cards.strength_judge[:result][0][:card]).to eq @request[0]
        expect(@cards.strength_judge[:result][1][:card]).to eq @request[1]
      end
    end
    context '正常系確認' do
      example '@responseのhandがストレート・フラッシュと、フルハウスになってること' do
        expect(@cards.strength_judge[:result][0][:hand]).to eq 'ストレート・フラッシュ'
        expect(@cards.strength_judge[:result][1][:hand]).to eq 'フルハウス'
      end
    end
  end
end
