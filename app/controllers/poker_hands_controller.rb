class PokerHandsController < ApplicationController
require "./app/services/poker_hand"

  def top
    @poker_hand = PokerHand.new("")

  end

  def judge
    @poker_hand = PokerHand.new(params[:hands])
    if @poker_hand.valid? == false
      render("poker_hands/top")
    else
    #格納した数字を元に各メソッドを呼び出し
      @poker_hand.finalj = @poker_hand.judge
      render("poker_hands/top")
    end
  end

end
