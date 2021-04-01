# ポーカーの手札のクラス
class PokerHand
  attr_accessor :hand
  attr_reader :cards, :suits, :numbers, :same_number_pair, :straight, :flash, :pair, :role, :error_message

  FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/.freeze
  LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/.freeze
  EXTRACTNUMBER = /([1-9]|1[0-3])\b/.freeze
  EXTRACTSUIT = /S|D|C|H/.freeze

  def initialize(hand)
    @hand = hand
    @cards = @hand.split(' ')
  end

  # 入力チェック
  def valid?
    if valid_format? == false
      false
    elsif valid_letter? == false
      false
    elsif duplicated? == false
      false
    else
      true
    end
  end

  # flash,straightの判定とsame_number_pairに基づき役名の判定を行う
  def judge
    flash?
    straight?
    pair_check
    case [@flash, @straight, @pair]
    when [true, true, 'highcard']
      @role =  'ストレート・フラッシュ'
    when [false, true, 'highcard']
      @role =  'ストレート'
    when [true, false, 'highcard']
      @role =  'フラッシュ'
    when [false, false, 'fourcard']
      @role =  'フォーカード'
    when [false, false, 'fullhouse']
      @role =  'フルハウス'
    when [false, false, 'threecard']
      @role =  'スリーカード'
    when [false, false, 'twopair']
      @role =  'ツーペア'
    when [false, false, 'onepair']
      @role =  'ワンペア'
    when [false, false, 'highcard']
      @role =  'ハイカード'
    end
  end

  # 手札（hand）が半角スペースで区切られているか、また5枚のカードから構成されているかの形式チェック
  def valid_format?
    if @hand.match(FORMATCHECK)
      true
    else
      @error_message = ' 5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
      false
    end
  end

  # カード（cards）の形式が間違ってないかチェック
  def valid_letter?
    if @cards.grep(LETTERCHECK).count == 5
      true
    else
      @error_message = ''
      @cards.each_with_index do |card, i|
        @error_message += "#{i + 1}番目のカード指定文字が不正です。（#{@cards[i]}）\r" unless card.match(LETTERCHECK)
      end
      @error_message += '半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
      false
    end
  end

  # カードが重複してないかチェック
  def duplicated?
    if @cards.uniq.length == 5
      true
    else
      @error_message = 'カードが重複してます。'
      false
    end
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
  def pair_check
    @numbers = [@cards[0][EXTRACTNUMBER].to_i,
                @cards[1][EXTRACTNUMBER].to_i,
                @cards[2][EXTRACTNUMBER].to_i,
                @cards[3][EXTRACTNUMBER].to_i,
                @cards[4][EXTRACTNUMBER].to_i]
    @same_number_pair = @numbers.group_by { |card| card }.values.map(&:count)
    @pair = if @same_number_pair.max == 4
              'fourcard'
            elsif @same_number_pair.max == 3 && @same_number_pair.min == 2
              'fullhouse'
            elsif @same_number_pair.max == 3 && @same_number_pair.min == 1
              'threecard'
            elsif @same_number_pair.max == 2 && @same_number_pair.sort[-2] == 2
              'twopair'
            elsif @same_number_pair.max == 2 && @same_number_pair.sort[-2] == 1
              'onepair'
            else
              'highcard'
            end
  end

  private :flash?, :straight?, :pair, :valid_format?, :valid_letter?, :duplicated?
end
