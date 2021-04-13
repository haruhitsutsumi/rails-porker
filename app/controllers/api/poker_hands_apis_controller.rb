# ポーカーのAPIのコントローラー
class Api::PokerHandsApisController < ApplicationController
  require './app/services/poker_hand'
  require './app/services/api/poker_hand_api'
  include PokerHandApi

  def top
    # jsonをパラメータで受け取る
    @cards = params[:cards]
    strength_judge

    # json形式で返す
    render json: @response
  end
end
