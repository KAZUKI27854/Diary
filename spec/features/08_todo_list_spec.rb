require 'rails_helper'

describe '8.ユーザログイン後のTodoリスト関連のテスト', type: :feature, js: true do
  let!(:user) { create(:user) }
  let!(:stage) { create(:stage) }
  let!(:goal) { create(:goal, user_id: user.id) }
  let!(:document) { create(:document, user_id: user.id, goal_id: goal.id) }

  before do
    login_as(user, :scope => :user)
    visit todo_lists_path
  end

  context 'リンクのテスト' do
    before do
      all('.my-page__menu--icon')[3].click
    end

    it 'Todoリスト一覧ページで扉のアイコンをクリックするとマイページへ遷移する' do
      expect(current_path).to eq my_page_path
    end

    it 'マイページでTodoリストアイコンをクリックするとTodoリスト一覧へ遷移する' do
      visit current_path
      all('.my-page__menu--icon')[3].click

      expect(page).to have_selector '.todo-lists'
      expect(current_path).to eq todo_lists_path
    end
  end

  context 'フォーム非表示確認テスト' do
    it '作成フォームが表示されていない' do
      expect(page).not_to have_selector '.todo-lists__form--create'
    end

    it '編集フォームが表示されていない' do
      expect(page).not_to have_selector '.todo-lists__form--edit'
    end
  end

  context 'Todoリスト作成のテスト' do
    before do
      find('.todo-lists__icon--create').click
    end

    it '作成アイコンをクリックするとフォームが表示される' do
      expect(page).to have_selector '.todo-lists__form--create'
    end

    it '期限の入力フォームが表示される' do
      expect(page).to have_field 'todo_list[deadline]'
    end

    it '目標の入力フォームが表示される' do
      expect(page).to have_field 'todo_list[goal_id]'
    end

    it 'やることの入力フォームが表示される' do
      expect(page).to have_field 'todo_list[body]'
    end

    it 'Todoリスト作成成功のテスト' do
      fill_in 'todo_list[deadline]', with: Faker::Date.in_date_period
      within '#todo_list_goal_id' do
        select goal.category
      end
      fill_in 'todo_list[body]', with: 'テストを実行する'
      expect{ click_button 'ついか' }.to change{ TodoList.count }.by(1)
    end

    it 'Todoリスト作成失敗のテスト' do
      fill_in 'todo_list[body]', with: ''
      expect{ click_button 'ついか' }.to change{ TodoList.count }.by(0)
      expect(page).to have_selector '.error__message'
    end

    it 'エラーメッセージ表示後にTodoリストを作成すると、エラーメッセージが消える' do
      fill_in 'todo_list[body]', with: ''
      click_button 'ついか'

      within '#todo_list_goal_id' do
        select goal.category
      end
      fill_in 'todo_list[body]', with: 'テストを実行する'
      click_button 'ついか'

      expect(page).not_to have_selector '.error__message'
    end
  end
end