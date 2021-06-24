require 'rails_helper'

RSpec.describe 'TodoListモデルのテスト', type: :model do
  it '全ての項目を入力すればデータ保存ができる' do
    expect(build(:todo_list)).to be_valid
  end

  describe 'カラムごとのバリデーションとエラーメッセージのテスト' do
    subject { todo_list.valid? }

    let(:todo_list) { build(:todo_list) }

    context 'bodyカラム' do
      it '空欄の場合保存に失敗し、空白に関するエラーメッセージが返される' do
        todo_list.body = ''
        is_expected.to eq false
        expect(todo_list.errors[:body]).to include("を入力してください")
      end
      it '100文字以内であること: 101文字は保存に失敗し、文字数超過のエラーメッセージが返される' do
        todo_list.body = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
        expect(todo_list.errors[:body]).to include("は100文字以内で入力してください")
      end
      it '100文字以内であること: 100文字は保存に成功する' do
        todo_list.body = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
    end

    context 'deadlineカラム' do
      it '空欄の場合でも保存に成功する' do
        todo_list.deadline = ''
        is_expected.to eq true
      end
      it '昨日以前の日付の場合保存に失敗し、日付に関するエラーメッセージが返される' do
        todo_list.deadline = Date.today - 1
        is_expected.to eq false
        expect(todo_list.errors[:deadline]).to include("は、本日以降の日付を入力して下さい")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'userモデルとの関係' do
      it 'N:1となっている' do
        expect(TodoList.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'goalモデルとの関係' do
      it 'N:1となっている' do
        expect(TodoList.reflect_on_association(:goal).macro).to eq :belongs_to
      end
    end
  end
end
