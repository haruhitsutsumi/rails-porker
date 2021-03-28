class PokerHand
  attr_accessor :hand
  attr_reader :cards, :suits, :numbers, :same_number_pair, :straight, :flash, :pair, :finalj, :error_message, :format_check, :letter_check, :duplicate_check

  FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/
  LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/
  EXTRACTNUMBER = /([1-9]|1[0-3])\b/
  EXTRACTSUIT = /S|D|C|H/

  def initialize(hand)
    @hand = hand
    @cards = @hand.split(" ")
  end

  # 入力チェック
  def valid?
    format_check?
    letter_check?
    duplicate_check?
    if @format_check == false
      @error_message = "5つのカード指定文字を半角スペース区切りで入力してください。（例：" + "S1 H3 D9 C13 S11" + "）"
      return false
    elsif @letter_check == false
      @error_message = ""
      @cards.each_with_index do |card, i|
        @error_message += "#{i + 1}番目のカード指定文字が不正です。（#{@cards[i]}）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。" if card.match(LETTERCHECK) == nil
      end
      return false
    elsif @duplicate_check == false
      @error_message = "カードが重複してます。"
      return false
    else
      return true
    end
  end

  # flash,straightの判定とsame_number_pairに基づき役名の判定を行う
  def judge
    flash?
    straight?
    pair
    case [@flash, @straight, @pair]
    when [true, true, "highcard"]
      @finalj =  "ストレート・フラッシュ"
    when [false, true, "highcard"]
      @finalj =  "ストレート"
    when [true, false, "highcard"]
      @finalj =  "フラッシュ"
    when [false, false, "fourcard"]
      @finalj =  "フォーカード"
    when [false, false, "fullhouse"]
      @finalj =  "フルハウス"
    when [false, false, "threecard"]
      @finalj =  "スリーカード"
    when [false, false, "twopair"]
      @finalj =  "ツーペア"
    when [false, false, "onepair"]
      @finalj =  "ワンペア"
    when [false, false, "highcard"]
      @finalj =  "ハイカード"
    end
  end

  # 手札（hand）が半角スペースで区切られているか、また5枚のカードから構成されているかの形式チェック
  def format_check?
    @format_check != (@hand.match(FORMATCHECK).nil?)
  end

  # カード（cards）の形式が間違ってないかチェック
  def letter_check?
    @letter_check = (@cards.grep(LETTERCHECK).count == 5)
  end

  # カードが重複してないかチェック
  def duplicate_check?
    @duplicate_check = (@cards.uniq.length == 5)
  end

  # flashの判定を行う
  def flash?
    @suits = [@cards[0][EXTRACTSUIT],
              @cards[1][EXTRACTSUIT],
              @cards[2][EXTRACTSUIT],
              @cards[3][EXTRACTSUIT],
              @cards[4][EXTRACTSUIT]]
    @flash = @suits.uniq.length == 1
  end

  # straightの判定を行う
  def straight?
    @numbers = [@cards[0][EXTRACTNUMBER].to_i,
                @cards[1][EXTRACTNUMBER].to_i,
                @cards[2][EXTRACTNUMBER].to_i,
                @cards[3][EXTRACTNUMBER].to_i,
                @cards[4][EXTRACTNUMBER].to_i]
    @straight = if (@numbers.sort![4] - @numbers.sort![3] == 1 ||
                    @numbers.sort![4] - @numbers.sort![3] == 9) &&
                   (@numbers.sort![3] - @numbers.sort![2] == 1 ||
                    @numbers.sort![3] - @numbers.sort![2] == 9) &&
                   (@numbers.sort![2] - @numbers.sort![1] == 1 ||
                    @numbers.sort![2] - @numbers.sort![1] == 9) &&
                   (@numbers.sort![1] - @numbers.sort![0] == 1 ||
                    @numbers.sort![1] - @numbers.sort![0] == 9)
                  true
                else
                  false
                end
  end

  # pairの判定を行う
  def pair
    @numbers = [@cards[0][EXTRACTNUMBER].to_i,
                @cards[1][EXTRACTNUMBER].to_i,
                @cards[2][EXTRACTNUMBER].to_i,
                @cards[3][EXTRACTNUMBER].to_i,
                @cards[4][EXTRACTNUMBER].to_i]
    @same_number_pair = @numbers.group_by { |card| card }.values.map(&:count)
    @pair = if @same_number_pair.max == 4
              "fourcard"
            elsif @same_number_pair.max == 3 && @same_number_pair.min == 2
              "fullhouse"
            elsif @same_number_pair.max == 3 && @same_number_pair.min == 1
              "threecard"
            elsif @same_number_pair.max == 2 && @same_number_pair.sort[-2] == 2
              "twopair"
            elsif @same_number_pair.max == 2 && @same_number_pair.sort[-2] == 1
              "onepair"
            else
              "highcard"
            end
  end

  private :flash?, :straight?, :pair, :format_check?, :letter_check?, :duplicate_check?
end
