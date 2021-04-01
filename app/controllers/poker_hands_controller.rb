# ポーカーのコントローラー
class PokerHandsController < ApplicationController
  require './app/services/poker_hand'

  def top
    @poker_hand = PokerHand.new('')
  end

  def judge
    @poker_hand = PokerHand.new(params[:hand])
    if @poker_hand.valid?
      # 格納した数字を元に各メソッドを呼び出し
      @poker_hand.judge
    end
    render('poker_hands/top')
  end
end
