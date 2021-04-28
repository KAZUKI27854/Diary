require 'rails_helper'

RSpec.describe 'Documentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { document.valid? }

    let(:user) { create(:user) }
    let(:goal) { create(:goal, user_id: user.id) }
    let(:document) { build(:document, user_id: user.id, goal_id: goal.id) }

    context 'bodyカラム' do
      it '空欄でないこと' do
        document.body = ''
        is_expected.to eq false
      end
      it '100文字以内であること: 101文字は×' do
        document.body = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
      it '100文字以内であること: 100文字は〇' do
        document.body = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
    end

    context 'milestoneカラム' do
      it '空欄でないこと' do
        document.milestone = ''
        is_expected.to eq false
      end
      it '100文字以内であること: 101文字は×' do
        document.milestone = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
      it '100文字以内であること: 100文字は〇' do
        document.milestone = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
    end

    context 'add_levelカラム' do
      it '空欄でないこと' do
        document.add_level = ''
        is_expected.to eq false
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