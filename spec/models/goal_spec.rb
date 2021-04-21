require 'rails_helper'

RSpec.describe 'Goalモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { goal.valid? }

    let(:user) { create(:user) }
    let!(:goal) { build(:goal, user_id: user.id) }

    context 'categoryカラム' do
      it '空欄でないこと' do
        goal.category = ''
        is_expected.to eq false
      end
      it '10文字以内であること: 11文字は×' do
        goal.category = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
      it '10文字以内であること: 10文字は〇' do
        goal.category = Faker::Lorem.characters(number: 10)
        is_expected.to eq true
      end
    end

    context 'goal_statusカラム' do
      it '空欄でないこと' do
        goal.goal_status = ''
        is_expected.to eq false
      end
      it '100文字以内であること: 101文字は×' do
        goal.goal_status = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
      it '10文字以内であること: 100文字は〇' do
        goal.goal_status = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
    end

    context 'deadlineカラム' do
      it '空欄でないこと' do
        goal.deadline = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'userモデルとの関係' do
      it 'N:1となっている' do
        expect(Goal.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'documentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Goal.reflect_on_association(:documents).macro).to eq :has_many
      end
    end
  end
end