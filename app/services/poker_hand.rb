class PokerHand

attr_accessor :hand
attr_reader  :cards, :suits, :numbers, :same_number_pair, :straight, :flash, :pair, :finalj, :error_message, :format_check, :letter_check, :duplicate_check

FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/
LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/
EXTRACTNUMBER = /([1-9]|1[0-3])\b/
EXTRACTSUIT = /S|D|C|H/

  def initialize(hand)
    self.hand = hand
    self.cards = self.hand.split(" ")
    self.numbers=[
      self.cards[0][EXTRACTNUMBER].to_i,
      self.cards[1][EXTRACTNUMBER].to_i,
      self.cards[2][EXTRACTNUMBER].to_i,
      self.cards[3][EXTRACTNUMBER].to_i,
      self.cards[4][EXTRACTNUMBER].to_i]
    self.suits=[
      self.cards[0][EXTRACTSUIT],
      self.cards[1][EXTRACTSUIT],
      self.cards[2][EXTRACTSUIT],
      self.cards[3][EXTRACTSUIT],
      self.cards[4][EXTRACTSUIT]]
    self.same_number_pair = self.numbers.group_by{|han| han}.map{|k,v| v.count}
  end
  
  #入力チェック
  def valid?
    self.format_check?
    self.letter_check?
    self.duplicate_check?
    if self.format_check == false
      self.error_message ="5つのカード指定文字を半角スペース区切りで入力してください。（例："+"S1 H3 D9 C13 S11"+"）"
      return false
    elsif self.letter_check == false
      self.error_message=""
      self.cards.each_with_index do|card,i|
      self.error_message += "#{i+1}番目のカード指定文字が不正です。（#{self.cards[i]}）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。" if card.match(LETTERCHECK) == nil
      end
      return false
    elsif self.duplicate_check == false
      self.error_message ="カードが重複してます。"
      return false
    else
      return true
    end
  end

  #flash,straightの判定とsame_number_pairに基づき役名の判定を行う
  def judge
    self.flash?
    self.straight?
    self.pair
    case [self.flash,self.straight,self.pair]
    when [true,true,"highcard"]
      self.finalj =  "ストレート・フラッシュ"
    when [false,true,"highcard"]
      self.finalj =  "ストレート"
    when [true,false,"highcard"]
      self.finalj =  "フラッシュ"
    when [false,false,"fourcard"]
      self.finalj =  "フォーカード"
    when [false,false,"fullhouse"]
      self.finalj =  "フルハウス"
    when [false,false,"threecard"]
      self.finalj =  "スリーカード"
    when [false,false,"twopair"]
      self.finalj =  "ツーペア"
    when [false,false,"onepair"]
      self.finalj =  "ワンペア"
    when [false,false,"highcard"]
      self.finalj =  "ハイカード"
    end
  end

  #手札（hand）が半角スペースで区切られているか、また5枚のカードから構成されているかの形式チェック
  def format_check?
    if self.hand.match(FORMATCHECK) == nil
      self.format_check = false
    else
      self.format_check = true
    end
  end
  #カード（cards）の形式が間違ってないかチェック
  def letter_check?
    if self.cards.grep(LETTERCHECK).count != 5
      self.letter_check = false
    else
      self.letter_check = true
    end
  end
  #カードが重複してないかチェック
  def duplicate_check?
    if self.cards.uniq.length != 5
      self.duplicate_check = false
    else
      self.duplicate_check = true
    end
  end


  #flashの判定を行う
  def flash?
    if self.suits.uniq.length == 1
      self.flash = true
    else
      self.flash = false
    end
  end

  #straightの判定を行う
  def straight?
    if
     (self.numbers.sort![4] - self.numbers.sort![3] == 1||
     self.numbers.sort![4] - self.numbers.sort![3] == 9) &&
     (self.numbers.sort![3] - self.numbers.sort![2] == 1||
     self.numbers.sort![3] - self.numbers.sort![2] == 9) &&
     (self.numbers.sort![2] - self.numbers.sort![1] == 1||
     self.numbers.sort![2] - self.numbers.sort![1] == 9) &&
     (self.numbers.sort![1] - self.numbers.sort![0] == 1||
     self.numbers.sort![1] - self.numbers.sort![0] == 9)
     self.straight = true
    else
      self.straight = false
    end
  end

  #pairの判定を行う
  def pair
    if self.same_number_pair.max==4
      self.pair =  "fourcard"
    elsif self.same_number_pair.max== 3 && self.same_number_pair.min==2
      self.pair =  "fullhouse"
    elsif self.same_number_pair.max== 3 && self.same_number_pair.min==1
      self.pair =  "threecard"
    elsif self.same_number_pair.max== 2 && self.same_number_pair.sort[-2]==2
      self.pair =  "twopair"
    elsif self.same_number_pair.max== 2 && self.same_number_pair.sort[-2]==1
      self.pair =  "onepair"
    else
      self.pair =  "highcard"
    end
  end

  private :flash?, :straight?, :pair, :format_check?, :letter_check?, :duplicate_check?
  

end

