require 'rails_helper'

RSpec.describe 'Documentモデルのテスト', type: :model do
  it '全ての項目を入力すればデータ保存ができる' do
    expect(build(:document)).to be_valid
  end

  describe 'カラムごとのバリデーションとエラーメッセージのテスト' do
    subject { document.valid? }

    let(:document) { build(:document) }

    context 'bodyカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        document.body = ''

        is_expected.to eq false
        expect(document.errors[:body]).to include("を入力してください")
      end

      it '300文字以内であること: 301文字は保存に失敗し、文字数超過のエラーメッセージが返される' do
        document.body = Faker::Lorem.characters(number: 301)

        is_expected.to eq false
        expect(document.errors[:body]).to include("は300文字以内で入力してください")
      end

      it '300文字以内であること: 300文字は保存に成功する' do
        document.body = Faker::Lorem.characters(number: 300)
        is_expected.to eq true
      end
    end

    context 'milestoneカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        document.milestone = ''

        is_expected.to eq false
        expect(document.errors[:milestone]).to include("を入力してください")
      end

      it '100文字以内であること: 101文字は保存に失敗し、文字数超過のエラーメッセージが返される' do
        document.milestone = Faker::Lorem.characters(number: 101)

        is_expected.to eq false
        expect(document.errors[:milestone]).to include("は100文字以内で入力してください")
      end

      it '100文字以内であること: 100文字は保存に成功する' do
        document.milestone = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
    end

    context 'add_levelカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        document.add_level = ''

        is_expected.to eq false
        expect(document.errors[:add_level]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'userモデルとの関係' do
      it 'N:1となっている' do
        expect(Document.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'goalモデルとの関係' do
      it 'N:1となっている' do
        expect(Document.reflect_on_association(:goal).macro).to eq :belongs_to
      end
    end
  end
end
