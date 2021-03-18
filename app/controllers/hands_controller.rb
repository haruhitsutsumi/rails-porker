class HandsController < ApplicationController

#before_action :valid,{only:[:judge]}



  def top
    @input = nil
    @hand = Hand.new
  end

  def judge
    @hand = Hand.new(
      cards: params[:hands],
      hands: params[:hands].split(" ")
      )
    if @hand.valid == false
      @input = params[:hands]
      render("hands/top")
    else
    #格納した数字を元に各メソッドを呼び出し
      @hand.flashj = @hand.fjudge
      @hand.pairj = @hand.pjudge
      @hand.straightj = @hand.sjudge
      @hand.finalj = @hand.finaljudge
      @input = params[:hands]
      render("hands/top")
    end
  end

end


