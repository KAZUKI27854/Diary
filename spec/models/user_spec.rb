require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  it '全ての項目を入力すればデータ保存ができる' do
    expect(build(:user)).to be_valid
  end

  describe 'カラムごとのバリデーションテスト' do
    subject { user.valid? }

    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        user.name = ''
        is_expected.to eq false
        expect(user.errors[:name]).to include("を入力してください")
      end
      it '60文字以内であること: 61文字は保存に失敗し、文字数超過のエラーメッセージが返される' do
        user.name = Faker::Lorem.characters(number: 61)
        is_expected.to eq false
        expect(user.errors[:name]).to include("は60文字以内で入力してください")
      end
      it '60文字以内であること: 60文字は保存に成功する' do
        user.name = Faker::Lorem.characters(number: 60)
        is_expected.to eq true
      end
    end

    context 'emailカラム' do
      it '空白の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        user.email = ''
        is_expected.to eq false
        expect(user.errors[:email]).to include("を入力してください")
      end
      it '一意性がない場合保存に失敗し、既に存在しているというエラーメッセージが返される' do
        # DBにアクセスする為、createで作成
        user = create(:user)
        another_user = build(:user, email: user.email)
        another_user.valid?
        expect(another_user.errors[:email]).to include("はすでに存在します")
      end
    end

    context 'passwordカラム' do
      it '空白の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        user.password = ''
        is_expected.to eq false
        expect(user.errors[:password]).to include("を入力してください")
      end
      it '6文字以上であること: 5文字は保存に失敗し、文字数不足のエラーメッセージが返される' do
        user.password = Faker::Lorem.characters(number: 5)
        is_expected.to eq false
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
      it '6文字以上であること: 6文字であっても確認用パスワードが空白の場合、保存に失敗し不一致のエラーメッセージが返される' do
        user.password = Faker::Lorem.characters(number: 6)
        user.password_confirmation = ''
        is_expected.to eq false
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it '6文字以上であること: 6文字であっても確認用パスワードが異なる場合、保存に失敗し不一致のエラーメッセージが返される' do
        user.password = Faker::Lorem.characters(number: 6)
        user.password_confirmation = Faker::Lorem.characters(number: 6)
        is_expected.to eq false
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it '6文字以上であること: 6文字かつ確認用パスワードも一致する場合、保存に成功する' do
        user.password = Faker::Lorem.characters(number: 6)
        user.password_confirmation = user.password
        is_expected.to eq true
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'goalモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:goals).macro).to eq :has_many
      end
    end

    context 'documentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:documents).macro).to eq :has_many
      end
    end

    context 'todo_listモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:todo_lists).macro).to eq :has_many
      end
    end
  end
end
