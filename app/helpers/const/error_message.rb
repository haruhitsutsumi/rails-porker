module Const::ErrorMessage
  FORMATERROR = ' 5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"） '.freeze
  EACHLETTERERROR = " %<i>s番目のカード指定文字が不正です。（%<card>s）".freeze
  LETTERERROR = '半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。 '.freeze
  DUPLICATEERROR = 'カードが重複してます。'.freeze
end
