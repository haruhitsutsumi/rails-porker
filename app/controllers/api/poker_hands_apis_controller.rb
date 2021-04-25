# ポーカーのAPIのコントローラー
class Api::PokerHandsApisController < ApplicationController
  require './app/services/poker_hand'
  require './app/services/api/poker_hand_api_service'

  def judge
    # 受け取ったパラメータを引数にインスタンス生成
    @poker_hands = PokerHandApiService.new(params[:cards])
    @poker_hands.strength_judge

    # json形式で返す
    render json: @poker_hands.whole_result
  end
end
