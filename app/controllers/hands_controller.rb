class HandsController < ApplicationController
require "./app/services/hand"

  def top
    @input = nil
    @hand = Hand.new("")

  end

  def judge
    @hand = Hand.new(params[:hands])
    if @hand.valid? == false
      @input = params[:hands]
      render("hands/top")
    else
    #格納した数字を元に各メソッドを呼び出し
      @hand.finalj = @hand.judge
      @input = params[:hands]
      render("hands/top")
    end
  end

end
