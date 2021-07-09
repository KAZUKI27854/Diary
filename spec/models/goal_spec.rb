require 'rails_helper'

RSpec.describe 'Goalモデルのテスト', type: :model do
  it '全ての項目を入力すればデータ保存ができる' do
    expect(build(:goal)).to be_valid
  end

  describe 'カラムごとのバリデーションとエラーメッセージのテスト' do
    subject { goal.valid? }

    let(:goal) { build(:goal) }

    context 'categoryカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        goal.category = ''
        is_expected.to eq false
        expect(goal.errors[:category]).to include("を入力してください")
      end
      it '20文字以内であること: 21文字は保存に失敗し、文字数超過のエラーメッセージが返される' do
        goal.category = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
        expect(goal.errors[:category]).to include("は20文字以内で入力してください")
      end
      it '20文字以内であること: 20文字は保存に成功する' do
        goal.category = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
    end

    context 'goal_statusカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        goal.goal_status = ''
        is_expected.to eq false
        expect(goal.errors[:goal_status]).to include("を入力してください")
      end
      it '100文字以内であること: 101文字は保存に失敗し、文字数超過のエラーメッセージが返される' do
        goal.goal_status = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
        expect(goal.errors[:goal_status]).to include("は100文字以内で入力してください")
      end
      it '10文字以内であること: 100文字は保存に成功する' do
        goal.goal_status = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
    end

    context 'deadlineカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        goal.deadline = ''
        is_expected.to eq false
        expect(goal.errors[:deadline]).to include("を入力してください")
      end
      it '昨日以前の日付の場合保存に失敗し、日付に関するエラーメッセージが返される' do
        goal.deadline = Date.yesterday
        is_expected.to eq false
        expect(goal.errors[:deadline]).to include("は、本日以降の日付を入力して下さい")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'userモデルとの関係' do
      it 'N:1となっている' do
        expect(Goal.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'stageモデルとの関係' do
      it 'N:1となっている' do
        expect(Goal.reflect_on_association(:stage).macro).to eq :belongs_to
      end
    end

    context 'documentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Goal.reflect_on_association(:documents).macro).to eq :has_many
      end
    end

    context 'todo_listモデルとの関係' do
      it '1:Nとなっている' do
        expect(Goal.reflect_on_association(:todo_lists).macro).to eq :has_many
      end
    end
  end
end
