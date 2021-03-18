class Hand < ApplicationRecord

attr_accessor :hands, :cards, :finalj, :error_message

FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/
LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/

=begin
def initialize(cards)
  self.cards = cards
  self.hands = self.cards.split(" ")
end
=end

  def valid?
    #全体の形式チェック
    if self.cards.match(FORMATCHECK) == nil
      self.error_message ="5つのカード指定文字を半角スペース区切りで入力してください。（例："+"S1 H3 D9 C13 S11"+"）"
      @input = self.cards
      return false

    #文字形式チェック
    elsif
      self.hands[0].match(LETTERCHECK) == nil ||
      self.hands[1].match(LETTERCHECK) == nil ||
      self.hands[2].match(LETTERCHECK) == nil||
      self.hands[3].match(LETTERCHECK) == nil||
      self.hands[4].match(LETTERCHECK) == nil

      self.error_message=""
      self.hands.each_with_index do|card,i|
        if card.match(LETTERCHECK) == nil
          self.error_message += "#{i+1}番目のカード指定文字が不正です。（#{self.hands[i]}）\r"
        end
      end
      self.error_message +="半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      return false

    #重複チェック
    elsif self.hands.uniq.length != 5
      self.error_message ="カードが重複してます。"
      return false
    end
  end

  #flash,pair,straightの判定に基づき役名の判定を行う
  def finaljudge
    if self.flash? == true && self.straight? == true
      return "ストレート・フラッシュ"
    elsif self.flash? == true && self.straight? == false
      return "フラッシュ"
    elsif self.flash? == false && self.straight? == true
      return "ストレート"
    elsif self.flash? == false && self.straight? == false && self.pairjudge == "highcard"
      return "ハイカード"
    elsif self.pairjudge == "fourcard"
      return "フォーカード"
    elsif self.pairjudge == "fullhouse"
      return "フルハウス"
    elsif self.pairjudge == "threecard"
      return "スリーカード"
    elsif self.pairjudge == "twopair"
      return "ツーペア"
    elsif self.pairjudge == "onepair"
      return "ワンペア"
    else
      return "プータロー"
    end
  end

  #flashの判定を行う
  def flash?
    if [self.hands[0][/s|d|c|h/],
      self.hands[1][/s|d|c|h/],
      self.hands[2][/s|d|c|h/],
      self.hands[3][/s|d|c|h/],
      self.hands[4][/s|d|c|h/]].uniq.length == 1
      return true
    else
      return false
    end
  end

  #straightの判定を行う
  def straight?
    handsarraynum = [
      self.hands[0][/([1-9]|1[0-3])\b/].to_i,
      self.hands[1][/([1-9]|1[0-3])\b/].to_i,
      self.hands[2][/([1-9]|1[0-3])\b/].to_i,
      self.hands[3][/([1-9]|1[0-3])\b/].to_i,
      self.hands[4][/([1-9]|1[0-3])\b/].to_i]

    if
       (handsarraynum.sort![4] - handsarraynum.sort![3] == 1||9) &&
       (handsarraynum.sort![3] - handsarraynum.sort![2] == 1||9) &&
       (handsarraynum.sort![2] - handsarraynum.sort![1] == 1||9) &&
       (handsarraynum.sort![1] - handsarraynum.sort![0] == 1||9)
      return true
    else
      return false
    end
    
  end

  #pairの判定を行う
  def pairjudge
    #インスタンスで持ってる各カードから数字を抽出し、配列を作成
    handsarraynum = [
      self.hands[0][/([1-9]|1[0-3])\b/],
      self.hands[1][/([1-9]|1[0-3])\b/],
      self.hands[2][/([1-9]|1[0-3])\b/],
      self.hands[3][/([1-9]|1[0-3])\b/],
      self.hands[4][/([1-9]|1[0-3])\b/]]

    #数字だけの配列を、数字ごとにグルーピングしたハッシュを作り、ハッシュのキーをカウントした配列を作ってる
    handsarraynumcount = handsarraynum.group_by{|han| han}.map{|k,v| v.count}

    if handsarraynumcount.max==4
      return "fourcard"
    elsif handsarraynumcount.max== 3 && handsarraynumcount.min==2
      return "fullhouse"
    elsif handsarraynumcount.max== 3 && handsarraynumcount.min==1
      return "threecard"
    elsif handsarraynumcount.max== 2 && handsarraynumcount.sort[-2]==2
      return "twopair"
    elsif handsarraynumcount.max== 2 && handsarraynumcount.sort[-2]==1
      return "onepair"
    else
      return "highcard"
    end
  end

#  private :flash?, :pairjudge, :straight?

end
