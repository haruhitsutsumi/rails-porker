class Hand < ApplicationRecord

attr_accessor :hands, :cards, :array1, :array2, :array3, :array4, :array5
attr_accessor :flashj, :pairj, :straightj, :finalj

def initialize(cards)
  self.cards = cards
  self.hands = self.cards.split(" ")
  self.array1 = self.hands[0]
  self.array2 = self.hands[1]
  self.array3 = self.hands[2]
  self.array4 = self.hands[3]
  self.array5 = self.hands[4]
end


  #flashの判定を行う
  def fjudge
    if [self.array1[/s|d|c|h/],
      self.array2[/s|d|c|h/],
      self.array3[/s|d|c|h/],
      self.array4[/s|d|c|h/],
      self.array5[/s|d|c|h/]].uniq.length == 1
      @test="123"
      return true
    else
      return false
    end
  end

  #straightの判定を行う
  def sjudge
    handsarraynum = [
      self.array1[/([1-9]|1[0-3])\b/].to_i,
      self.array2[/([1-9]|1[0-3])\b/].to_i,
      self.array3[/([1-9]|1[0-3])\b/].to_i,
      self.array4[/([1-9]|1[0-3])\b/].to_i,
      self.array5[/([1-9]|1[0-3])\b/].to_i]

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
      self.array1[/([1-9]|1[0-3])\b/],
      self.array2[/([1-9]|1[0-3])\b/],
      self.array3[/([1-9]|1[0-3])\b/],
      self.array4[/([1-9]|1[0-3])\b/],
      self.array5[/([1-9]|1[0-3])\b/]]

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
