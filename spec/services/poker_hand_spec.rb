# ポーカーのサービス層のテストクラス
require 'rails_helper'

RSpec.describe 'Service層のテスト' do
  #  describe `イニシャライザのテスト` do
  #  end
  describe 'バリデーションのメソッドのテスト' do
    it '文字列の形式が間違っているとfalseが返ること' do
      hand = PokerHand.new('S1 C3 H4 D8')
      expect(hand.valid?).to eq false
    end
    it '文字の形式が間違っているとfalseが返ること'
    it '文字が重複しているとfalseが返ること'
    it '正しい形式の時、なにも返らないこと'
  end
  #  describe `約判定メソッドのテスト` do
  #  end
end
