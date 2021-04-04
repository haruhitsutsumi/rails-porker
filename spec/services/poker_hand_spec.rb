# ポーカーのサービス層のテストクラス
require 'rails_helper'

RSpec.describe 'Service層のテスト' do
  describe 'バリデーションのメソッドのテスト' do
    describe '手札の枚数・形式チェック' do
      context 'カードが4枚のとき' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 C3 H4 D8')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq ' 5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"） '
        end
      end
      context 'カードが6枚のとき' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 C3 H4 D8 S12 S13 S7')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq ' 5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"） '
        end
      end
      context 'カードがスラッシュで区切られてるとき' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1/C3/H4/D8/D9')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq ' 5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"） '
        end
      end
    end
    describe 'カードの形式チェック' do
      context '数字が1~13以外の時' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 C14 H4 D8 C1')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq "2番目のカード指定文字が不正です。（C14）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        end
      end
      context '数字がない時' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 C H4 D8 C1')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq "2番目のカード指定文字が不正です。（C）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        end
      end
      context 'スーとがSDHC以外の時' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 A13 H4 D8 C1')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq "2番目のカード指定文字が不正です。（A13）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        end
      end
      context 'スーとがない時' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 13 H4 D8 C1')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq "2番目のカード指定文字が不正です。（13）\r半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        end
      end
    end
    describe 'カードの重複チェック' do
      context 'カードが重複している時' do
        example 'falseが返ること' do
          hand = PokerHand.new('S1 S1 H4 D8 C1')
          expect(hand.valid?).to eq false
          expect(hand.error_message).to eq 'カードが重複してます。'
        end
      end
    end
    describe '正常系確認' do
      context '正しい手札のとき' do
        example 'trueが返ること' do
          hand = PokerHand.new('S1 D1 H4 D8 C1')
          expect(hand.valid?).to eq true
        end
      end
    end
  end
  describe '役判定のメソッドのテスト' do
    context 'ペアが一組のとき' do
      example '@roleがワンペア' do
        hand = PokerHand.new('S1 D1 H3 C2 C11')
        expect(hand.judge).to eq 'ワンペア'
      end
    end
    context 'ペアが二組のとき' do
      example '@roleがツーペア' do
        hand = PokerHand.new('S1 D1 H2 C2 C11')
        expect(hand.judge).to eq 'ツーペア'
      end
    end
    context '同じ数字のカードが3枚のとき' do
      example '@roleがスリーカード' do
        hand = PokerHand.new('S1 D1 H1 C2 C11')
        expect(hand.judge).to eq 'スリーカード'
      end
    end
    context '同じ数字のカードが4枚のとき' do
      example '@roleがフォーカード' do
        hand = PokerHand.new('S1 D1 H1 C1 C11')
        expect(hand.judge).to eq 'フォーカード'
      end
    end
    context '同じ数字のカードが3枚、2枚のとき' do
      example '@roleがフルハウス' do
        hand = PokerHand.new('S1 D1 H1 C2 D2')
        expect(hand.judge).to eq 'フルハウス'
      end
    end
    context '数字が連続していてマークが同じでないとき' do
      example '@roleがストレート' do
        hand = PokerHand.new('S1 D2 H3 C4 C5')
        expect(hand.judge).to eq 'ストレート'
      end
    end
    context '数字が連続していてマークが同じのとき' do
      example '@roleがストレート・フラッシュ' do
        hand = PokerHand.new('S1 S2 S3 S4 S5')
        expect(hand.judge).to eq 'ストレート・フラッシュ'
      end
    end
    context '数字が連続していなくてマークが同じとき' do
      example '@roleがフラッシュ' do
        hand = PokerHand.new('S1 S2 S3 S4 S11')
        expect(hand.judge).to eq 'フラッシュ'
      end
    end
    context '数字が連続していなく、マークが同じでなく、ペアがない' do
      example '@roleがハイカード' do
        hand = PokerHand.new('S1 D3 H4 C5 C6')
        expect(hand.judge).to eq 'ハイカード'
      end
    end
  end
end
