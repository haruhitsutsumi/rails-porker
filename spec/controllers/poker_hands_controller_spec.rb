# ポーカーのコントローラーのテストクラス
require 'rails_helper'

RSpec.describe PokerHandsController do
  describe 'Get #top' do
    before do
      get :top
    end
    example 'ステータスが200であること' do
      expect(response.status).to eq 200
    end
    example 'topテンプレードを表示すること' do
      expect(response).to render_template :top
    end
    example '@poker_handが引数''で生成されていること' do
      poker_hand = PokerHand.new('')
      expect(assigns(:poker_hand).hand).to eq poker_hand.hand
      expect(assigns(:poker_hand).cards).to eq poker_hand.cards
    end
  end
  describe 'Post #judge' do
    describe 'valid?メソッドの結果がfalseの時' do
      before do
        post :judge, params: {hand: 'S1 C3 H4 D8'}
      end
      example 'ステータスが200であること' do
        expect(response.status).to eq 200
      end
      example 'topテンプレードを表示すること' do
        expect(response).to render_template :top
      end
      example '@roleがnilであること' do
        expect(assigns(:poker_hand).role).to eq nil
      end
    end
    describe 'valid?メソッドの結果がtrueの時' do
      before do
        post :judge, params: {hand: 'S1 C3 H4 D8 D9'}
      end
      example 'ステータスが200であること' do
        expect(response.status).to eq 200
      end
      example 'topテンプレードを表示すること' do
        expect(response).to render_template :top
      end
      example '@roleがnilではないこと' do
        expect(assigns(:poker_hand).role).not_to eq nil
      end
    end
  end
end
