class PokerHand

attr_accessor :hand
attr_reader  :cards, :suits, :numbers, :same_number_pair, :straight, :flash, :finalj, :error_message

FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/
LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/

  def initialize(hand)
    self.hand = hand
    self.cards = self.hand.split(" ")
    self.numbers=[
      self.cards[0][/([1-9]|1[0-3])\b/].to_i,
      self.cards[1][/([1-9]|1[0-3])\b/].to_i,
      self.cards[2][/([1-9]|1[0-3])\b/].to_i,
      self.cards[3][/([1-9]|1[0-3])\b/].to_i,
      self.cards[4][/([1-9]|1[0-3])\b/].to_i]
    self.suits=[
      self.cards[0][/S|D|C|H/],
      self.cards[1][/S|D|C|H/],
      self.cards[2][/S|D|C|H/],
      self.cards[3][/S|D|C|H/],
      self.cards[4][/S|D|C|H/]]
    self.same_number_pair = self.numbers.group_by{|han| han}.map{|k,v| v.count}
  end
  
  def valid?
    #全体の形式チェック
    if self.hand.match(FORMATCHECK) == nil
      self.error_message ="5つのカード指定文字を半角スペース区切りで入力してください。（例："+"S1 H3 D9 C13 S11"+"）"
      return false
    #文字形式チェック
    elsif self.cards.grep(LETTERCHECK).count != 5
      self.error_message=""
      self.cards.each_with_index do|card,i|
        self.error_message += "#{i+1}番目のカード指定文字が不正です。（#{self.cards[i]}）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。" if card.match(LETTERCHECK) == nil
      end
      return false
    #重複チェック
    elsif self.cards.uniq.length != 5
      self.error_message ="カードが重複してます。"
      return false
    end
  end

  #flash,pair,straightの判定に基づき役名の判定を行う
  def judge
    self.flash?
    self.straight?
    if self.flash == true && self.straight == true
      self.finalj =  "ストレート・フラッシュ"
    elsif self.flash == true && self.straight == false
      self.finalj =  "フラッシュ"
    elsif self.flash == false && self.straight == true
      self.finalj =  "ストレート"
    elsif self.same_number_pair.max==4
      self.finalj =  "フォーカード"
    elsif self.same_number_pair.max== 3 && self.same_number_pair.min==2
      self.finalj =  "フルハウス"
    elsif self.same_number_pair.max== 3 && self.same_number_pair.min==1
      self.finalj =  "スリーカード"
    elsif self.same_number_pair.max== 2 && self.same_number_pair.sort[-2]==2
      self.finalj =  "ツーペア"
    elsif self.same_number_pair.max== 2 && self.same_number_pair.sort[-2]==1
      self.finalj =  "ワンペア"
    else
      self.finalj =  "ハイカード"
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

  private :flash?, :straight?

end

