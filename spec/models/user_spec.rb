require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let(:user) { create(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '10文字以内であること: 11文字は×' do
        user.name = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
      it '10文字以内であること: 10文字は〇' do
        user.name = Faker::Lorem.characters(number: 10)
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
  end
end
