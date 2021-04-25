# ポーカーAPIのメソッドをまとめるクラス
class PokerHandApiService
  attr_accessor :cards,:whole_result
  attr_reader :best

  require './app/services/poker_hand'
  def initialize(cards)
    # 受け取ったjsonを配列として格納
    @cards = cards
  end

  def strength_judge
    # validを通った@poker_handオブジェクトを格納する配列
    poker_hand_array = []
    # validを通らなかった@poker_handオブジェクトを格納する配列
    error_hand_array = []
    # @poker_handオブジェクトの強さだけを格納する配列
    strength_array = []
    # 文字列配列に対する繰り返し処理
    @cards.each do |card|
      poker_hand = PokerHand.new(card)
      # バリデーションチェック
      if poker_hand.valid? == false
        # 役と強さ付与
        poker_hand.judge
        # 強さを配列に格納
        strength_array.push(poker_hand.role[:strength])
        # オブジェクトを配列に格納
        poker_hand_array.push(poker_hand)
      else
        error_hand_array.push(poker_hand)
      end
    end
    @whole_result = {}

    # ハッシュに変形
    if poker_hand_array.empty? == false
      @best = strength_array.max
      results = poker_hand_array.map do |poker_hand|
        { "card": poker_hand.hand, "hand": poker_hand.role[:name], "best": poker_hand.role[:strength] == @best }
      end
      @whole_result[:results] = results
    end
    if error_hand_array.empty? == false
      errors = []
      error_hand_array.map do |error_hand|
        if error_hand.letter_error_messages.nil? == false
          error_hand.letter_error_messages.map do |letter_error_message|
            error = { "card": error_hand.hand, "message": letter_error_message }
            errors.push(error)
          end
        else
          error = { "card": error_hand.hand, "message": error_hand.error_message }
          errors.push(error)
        end
      end
      @whole_result[:errors] = errors
    end
  end
end
