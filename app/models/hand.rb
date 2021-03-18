class Hand < ApplicationRecord

attr_accessor :hands, :cards, :array1, :array2, :array3, :array4, :array5
attr_accessor :flashj, :pairj, :straightj, :finalj, :error_message

FORMATCHECK = /\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/
LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/


=begin
def initialize(cards)
  self.cards = cards
  self.hands = self.cards.split(" ")
  self.hands[0] = self.hands[0]
  self.hands[1] = self.hands[1]
  self.hands[2] = self.hands[2]
  self.hands[3] = self.hands[3]
  self.hands[4] = self.hands[4]
end
=end

  def valid
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

        #各文字の形式をチェックする
        if self.hands[0].match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          @array1em = "1番目のカード指定文字が不正です。（#{self.hands[0]}）\r"
        end
        if self.hands[1].match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          @array2em = "2番目のカード指定文字が不正です。（#{self.hands[1]}）\r"
        end
        if self.hands[2].match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          @array3em = "3番目のカード指定文字が不正です。（#{self.hands[2]}）\r"
        end
        if self.hands[3].match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          @array4em = "4番目のカード指定文字が不正です。（#{self.hands[3]}）\r"
        end
        if self.hands[4].match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          @array5em = "5番目のカード指定文字が不正です。（#{self.hands[4]}）\r"
        end
        
      self.error_message = "#{@array1em}#{@array2em}#{@array3em}#{@array4em}#{@array5em}半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      return false
#     @input = self.cards
    #重複チェック
    elsif [self.hands[0],self.hands[1],self.hands[2],self.hands[3],self.hands[4]].uniq.length != 5
      self.error_message ="カードが重複してます。"
#    @input = self.cards
      return false
    end
  end




  #flashの判定を行う
  def fjudge
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
  def sjudge
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
  def pjudge
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

  #flash,pair,straightの判定に基づき役名の判定を行う
  def finaljudge
    if self.flashj == true && self.straightj == true
      return "ストレート・フラッシュ"
    elsif self.flashj == true && self.straightj == false
      return "フラッシュ"
    elsif self.flashj == false && self.straightj == true
      return "ストレート"
    elsif self.flashj == false && self.straightj == false && self.pairj == "highcard"
      return "ハイカード"
    elsif self.pairj == "fourcard"
      return "フォーカード"
    elsif self.pairj == "fullhouse"
      return "フルハウス"
    elsif self.pairj == "threecard"
      return "スリーカード"
    elsif self.pairj == "twopair"
      return "ツーペア"
    elsif self.pairj == "onepair"
      return "ワンペア"
    else
      return "プータロー"
    end
  end




end
