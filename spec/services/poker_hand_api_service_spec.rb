# ポーカーapiのサービス層のテストクラス
require 'rails_helper'
require './app/services/api/poker_hand_api_service'

RSpec.describe 'Service層のテスト' do
  describe 'strength_judge 正常系確認' do
    before do
      @request = ["H1 H2 H3 H4 H5","H1 C1 S1 H2 C2","H1 C1 S1 H2 C13"]
      @cards = PokerHandApiService.new(@request)
      @cards.strength_judge
    end
    example '一番強い手札のbest判定がtrueになっており、それ以外がfalseになってること' do
      expect(@cards.whole_result[:results][0][:best]).to eq true
      expect(@cards.whole_result[:results][1][:best]).to eq false
      expect(@cards.whole_result[:results][2][:best]).to eq false
    end
    example '@responseの全てのcardが入力値と等しいこと' do
      expect(@cards.whole_result[:results][0][:card]).to eq @request[0]
      expect(@cards.whole_result[:results][1][:card]).to eq @request[1]
      expect(@cards.whole_result[:results][2][:card]).to eq @request[2]
    end
    example '@responseのhandがストレート・フラッシュと、フルハウスになってること' do
      expect(@cards.whole_result[:results][0][:hand]).to eq 'ストレート・フラッシュ'
      expect(@cards.whole_result[:results][1][:hand]).to eq 'フルハウス'
      expect(@cards.whole_result[:results][2][:hand]).to eq 'スリーカード'
    end
  end
  describe 'strength_judge 異常系確認' do
    context '一部正しくない形式の手札が入力された時' do
      example '正しくない手札にはカードと形式チェックのエラーメッセージが返ること' do
        @request = ["H1 H2 H3 H4 H5","H1 C1 S1 H2 C2","H1 C1 S1"]
        @cards = PokerHandApiService.new(@request)
        @cards.strength_judge
        expect(@cards.whole_result[:errors][0][:card]).to eq @request[2]
        expect(@cards.whole_result[:errors][0][:message]).to eq ' 5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"） '
      end
    end
    context '一部正しくない形式のカードを含む手札が入力された時' do
      example '正しくない手札にはカードと文字形式チェックのエラーメッセージが返ること' do
        @request = ["H1 H2 H3 H4 H5","H1 C1 S1 H2 C11","H1 C122 S122 H2 H3"]
        @cards = PokerHandApiService.new(@request)
        @cards.strength_judge
        expect(@cards.whole_result[:errors][0][:card]).to eq @request[2]
        expect(@cards.whole_result[:errors][0][:message]).to eq ' 2番目のカード指定文字が不正です。（C122）'
        expect(@cards.whole_result[:errors][1][:card]).to eq @request[2]
        expect(@cards.whole_result[:errors][1][:message]).to eq ' 3番目のカード指定文字が不正です。（S122）'
      end
      example 'カードが重複している手札が入力された時' do
        @request = ["H1 H2 H3 H4 H5","H1 C1 S1 H2 C11","H1 C12 S12 S12 S1"]
        @cards = PokerHandApiService.new(@request)
        @cards.strength_judge
        expect(@cards.whole_result[:errors][0][:card]).to eq @request[2]
        expect(@cards.whole_result[:errors][0][:message]).to eq 'カードが重複してます。'
      end
    end
  end
end
