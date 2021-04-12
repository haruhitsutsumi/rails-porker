# ポーカーのAPIのコントローラー
class Api::PokerHandsApisController < ApplicationController
  require './app/services/poker_hand'
  def top
    # jsonをパラメータで受け取る
    @cards = params[:cards]
    
    # 生成した@poker_handオブジェクトを格納する配列
    @poker_hand_array = []
    
    # @poker_handオブジェクトの強さだけを格納する配列
    @strength_arry = []
    
    # 文字列配列に対する繰り返し処理
    @cards.each do |card|
      # オブジェクト生成
      @poker_hand = PokerHand.new(card)
      # 役と強さ付与
      @poker_hand.judge
      #強さを配列に格納
      @strength_arry.push(@poker_hand.strength)
      #オブジェクトを配列に格納
      @poker_hand_array.push(@poker_hand)
    end
    
    # オブジェクト配列に繰り返し処理を行う
    @poker_hand_array.each do |poker_hand|
      # 役の強さが強さ配列の最大値と等しいかどうか確認
      if poker_hand.strength == @strength_arry.max
        poker_hand.best = true
      else
        poker_hand.best = false
      end
    end
    
    # jsonの形に変形
    @response = @poker_hand_array.map do |poker_hand|
      {"card": poker_hand.hand,"hand": poker_hand.role,"best": poker_hand.best}
    end
    @response = {"result": @response}
    render json: @response
  end
end
