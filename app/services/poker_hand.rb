# ポーカーの手札のクラス
class PokerHand
  attr_accessor :hand, :best
  attr_reader :cards, :suits, :numbers, :same_number_pair, :straight, :flash, :pair, :role, :error_message

  require './app/helpers/const/role'
  require './app/helpers/const/regex'
  require './app/helpers/const/error_message'
  include Const::Regex
  include Const::Role
  include Const::ErrorMessage

  def initialize(hand)
    @hand = hand
    @cards = @hand.split(' ')
    @role = {}
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
      @role = Const::Role::STRAIGHTFLASH
    when [false, true, 'highcard']
      @role = Const::Role::STRAIGHT
    when [true, false, 'highcard']
      @role = Const::Role::FLASH
    when [false, false, 'fourcard']
      @role = Const::Role::FOURCARD
    when [false, false, 'fullhouse']
      @role = Const::Role::FULLHOUSE
    when [false, false, 'threecard']
      @role = Const::Role::THREECARD
    when [false, false, 'twopair']
      @role = Const::Role::TWOPAIR
    when [false, false, 'onepair']
      @role = Const::Role::ONEPAIR
    when [false, false, 'highcard']
      @role = Const::Role::HIGHCARD
    end
  end

  # 手札（hand）が半角スペースで区切られているか、また5枚のカードから構成されているかの形式チェック
  def valid_format?
    if @hand.match(Const::Regex::FORMATCHECK)
      true
    else
      @error_message = Const::ErrorMessage::FORMATERROR
      false
    end
  end

  # カード（cards）の形式が間違ってないかチェック
  def valid_letter?
    if @cards.grep(Const::Regex::LETTERCHECK).count == 5
      true
    else
      @error_message = ''
      @cards.each_with_index do |card, i|
        next if card.match(Const::Regex::LETTERCHECK)

        @error_message += format(
          Const::ErrorMessage::EACHLETTERERROR,
          i: i + 1,
          card: card
        )
      end
      @error_message += Const::ErrorMessage::LETTERERROR
      false
    end
  end

  # カードが重複してないかチェック
  def duplicated?
    if @cards.uniq.length == 5
      true
    else
      @error_message = Const::ErrorMessage::DUPLICATEERROR
      false
    end
  end

  # flashの判定を行う
  def flash?
    @suits = [@cards[0][Const::Regex::EXTRACTSUIT],
              @cards[1][Const::Regex::EXTRACTSUIT],
              @cards[2][Const::Regex::EXTRACTSUIT],
              @cards[3][Const::Regex::EXTRACTSUIT],
              @cards[4][Const::Regex::EXTRACTSUIT]]
    @flash = @suits.uniq.length == 1
  end

  # straightの判定を行う
  def straight?
    @numbers = [@cards[0][Const::Regex::EXTRACTNUMBER].to_i,
                @cards[1][Const::Regex::EXTRACTNUMBER].to_i,
                @cards[2][Const::Regex::EXTRACTNUMBER].to_i,
                @cards[3][Const::Regex::EXTRACTNUMBER].to_i,
                @cards[4][Const::Regex::EXTRACTNUMBER].to_i]
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
