# ポーカーAPIのメソッドをまとめるクラス
class PokerHandApiService
  attr_accessor :cards
  attr_reader :response, :best

  require './app/services/poker_hand'
  def initialize(cards)
    # 受け取ったjsonを配列として格納
    @cards = cards
  end

  def strength_judge
    # 生成した@poker_handオブジェクトを格納する配列
    poker_hand_array = []
    # @poker_handオブジェクトの強さだけを格納する配列
    strength_arry = []
    # 文字列配列に対する繰り返し処理
    @cards.each do |card|
      # オブジェクト生成
      poker_hand = PokerHand.new(card)
      # 役と強さ付与
      poker_hand.judge
      # オブジェクトを配列に格納
      poker_hand_array.push(poker_hand)
      # 強さを配列に格納
      strength_arry.push(poker_hand.role[:strength])
    end

    @best = strength_arry.max

    # ハッシュに変形
    @response = poker_hand_array.map do |poker_hand|
      { "card": poker_hand.hand, "hand": poker_hand.role[:name], "best": poker_hand.role[:strength] == @best }
    end
    @response = { "result": @response }
  end
end
