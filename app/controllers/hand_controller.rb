class HandController < ApplicationController
before_action :setyear
before_action :inputcheck,{only:[:judge]}

  def top
    @hand = Hand.new
    @input = nil
  end

  def judge
    #格納した数字を元に各メソッドを呼び出し
    @hand.flashj = @hand.fjudge
    @hand.pairj = @hand.pjudge
    @hand.straightj = @hand.sjudge
    @hand.finalj = @hand.finaljudge
    @input = params[:hands]
    render("hand/top")
  end
  
  def inputcheck
    #文字列を空白で分割し配列にしている
    handsarray = params[:hands].split(" ")
      #配列の各数字を格納
      @hand = Hand.new(
        array1: handsarray[0],
        array2: handsarray[1],
        array3: handsarray[2],
        array4: handsarray[3],
        array5: handsarray[4])

    #全体の形式チェック
    if params[:hands].match(/\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b[ ]{1}\b[^ ]+\b$/) == nil
      @error_message ="5つのカード指定文字を半角スペース区切りで入力してください。（例："+"S1 H3 D9 C13 S11"+"）"
      @input = params[:hands]
      render("hand/top")
    #文字形式チェック

    elsif @hand.array1.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil ||
      @hand.array2.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil ||
      @hand.array3.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil||
      @hand.array4.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil||
      @hand.array5.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil

#繰り返しでかけないか模索中
=begin
        index = 1
        handsarray.each do |array|
          if array.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
            array="#{index}番目のカード指定文字が不正です。（#{array}）\r"
            index += 1
          end
        end
=end
        #各文字の形式をチェックする
        if @hand.array1.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          array1j = "false"
          @array1em = "1番目のカード指定文字が不正です。（#{@hand.array1}）\r"
        end
        if @hand.array2.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          array2j = "false"
          @array2em = "2番目のカード指定文字が不正です。（#{@hand.array2}）\r"
        end
        if @hand.array3.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          array3j = "false"
          @array3em = "3番目のカード指定文字が不正です。（#{@hand.array3}）\r"
        end
        if @hand.array4.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          array4j = "false"
          @array4em = "4番目のカード指定文字が不正です。（#{@hand.array4}）\r"
        end
        if @hand.array5.match(/\b[SCHD]([1-9]|1[0-3])\b/) == nil
          array5j = "false"
          @array5em = "5番目のカード指定文字が不正です。（#{@hand.array5}）\r"
        end
        
      @error_message = "#{@array1em}#{@array2em}#{@array3em}#{@array4em}#{@array5em}半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      @input = params[:hands]
    render("hand/top")
    #重複チェック
    elsif [@hand.array1,@hand.array2,@hand.array3,@hand.array4,@hand.array5].uniq.length != 5
      @error_message ="カードが重複してます。"
      @input = params[:hands]
      render("hand/top")
    end
  end

  def setyear
    @year=Date.current.strftime("%Y")
    
  end

end
