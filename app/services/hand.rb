class Hand

attr_accessor :hands, :cards, :finalj, :error_message

FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/
LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/

def initialize(cards)
  self.cards = cards
  self.hands = self.cards.split(" ")
end

  def valid?
    #全体の形式チェック
    if self.cards.match(FORMATCHECK) == nil
      self.error_message ="5つのカード指定文字を半角スペース区切りで入力してください。（例："+"S1 H3 D9 C13 S11"+"）"
      @input = self.cards
      return false
    #文字形式チェック
    elsif self.hands.grep(LETTERCHECK).count != 5
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
  def judge
    if flash?(self.hands) == true && straight?(self.hands) == true
      return "ストレート・フラッシュ"
    elsif flash?(self.hands) == true && straight?(self.hands) == false
      return "フラッシュ"
    elsif flash?(self.hands) == false && straight?(self.hands) == true
      return "ストレート"
    elsif flash?(self.hands) == false && straight?(self.hands) == false && pairjudge(self.hands) == "highcard"
      return "ハイカード"
    elsif pairjudge(self.hands) == "fourcard"
      return "フォーカード"
    elsif pairjudge(self.hands) == "fullhouse"
      return "フルハウス"
    elsif pairjudge(self.hands)  == "threecard"
      return "スリーカード"
    elsif pairjudge(self.hands) == "twopair"
      return "ツーペア"
    elsif pairjudge(self.hands) == "onepair"
      return "ワンペア"
    end
  end

  #flashの判定を行う
  def flash?(hands)
    if [hands[0][/S|D|C|H/],
      hands[1][/S|D|C|H/],
      hands[2][/S|D|C|H/],
      hands[3][/S|D|C|H/],
      hands[4][/S|D|C|H/]].uniq.length == 1

      return true
    else
      return false
    end
  end

  #straightの判定を行う
  def straight?(hands)
    handsarraynum = [
      hands[0][/([1-9]|1[0-3])\b/].to_i,
      hands[1][/([1-9]|1[0-3])\b/].to_i,
      hands[2][/([1-9]|1[0-3])\b/].to_i,
      hands[3][/([1-9]|1[0-3])\b/].to_i,
      hands[4][/([1-9]|1[0-3])\b/].to_i]

    if
       (handsarraynum.sort![4] - handsarraynum.sort![3] == 1||
       handsarraynum.sort![4] - handsarraynum.sort![3] == 9) &&
       (handsarraynum.sort![3] - handsarraynum.sort![2] == 1||
       handsarraynum.sort![3] - handsarraynum.sort![2] == 9) &&
       (handsarraynum.sort![2] - handsarraynum.sort![1] == 1||
       handsarraynum.sort![2] - handsarraynum.sort![1] == 9) &&
       (handsarraynum.sort![1] - handsarraynum.sort![0] == 1||
       handsarraynum.sort![1] - handsarraynum.sort![0] == 9)
      return true
    else
      return false
    end
  end

  #pairの判定を行う
  def pairjudge(hands)
    #インスタンスで持ってる各カードから数字を抽出し、配列を作成
    handsarraynum = [
      hands[0][/([1-9]|1[0-3])\b/],
      hands[1][/([1-9]|1[0-3])\b/],
      hands[2][/([1-9]|1[0-3])\b/],
      hands[3][/([1-9]|1[0-3])\b/],
      hands[4][/([1-9]|1[0-3])\b/]]

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
  private :flash?, :pairjudge, :straight?



end

