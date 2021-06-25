require 'rails_helper'

describe '8.ユーザログイン後のTodoリスト関連のテスト', type: :feature, js: true do
  # let!(:user) { create(:user) }
  # let!(:stage) { create(:stage) }
  # let!(:goal) { create(:goal, user_id: user.id) }
  # let!(:document) { create(:document, user_id: user.id, goal_id: goal.id) }

  let!(:goal) { create(:goal) }
  let!(:user) { User.first }

  before do
    login_as(user, :scope => :user)
    visit todo_lists_path
  end

  context 'リンクのテスト' do
    # ドキュメントが作成されていない状態ではTodoリストアイコンがクリックできない仕様の為
    let!(:document) { create(:document, user_id: user.id, goal_id: goal.id) }

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
      fill_in 'todo_list[deadline]', with: Date.today + 1
      within '#todo_list_goal_id' do
        select goal.category
      end
      fill_in 'todo_list[body]', with: 'テストを実行する'
      click_button 'ついか'
      sleep 1
      expect(TodoList.count).to eq 1
    end
    it 'Todoリスト作成失敗のテスト' do
      fill_in 'todo_list[body]', with: ''
      expect { click_button 'ついか' }.to change(TodoList, :count).by(0)
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

  context 'Todoリスト編集と削除のテスト' do
    let!(:goal_2) { create(:goal, user_id: user.id) }
    let!(:todo_list) { create(:todo_list, user_id: user.id, goal_id: goal.id) }

    before do
      visit current_path
      find('.todo-lists__link--edit').click
    end

    it '表示されているTodoリストをクリックすると、編集フォームが表示される' do
      expect(page).to have_selector '.todo-lists__form--edit'
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
    it 'Todoリスト編集成功のテスト' do
      within '#todo_list_goal_id' do
        select goal_2.category
      end
      fill_in 'todo_list[body]', with: 'テストを実行する'
      find('.todo-lists__link--update').click
      visit current_path
      expect(todo_list.reload.goal_id).to eq goal_2.id
      expect(todo_list.reload.body).to eq 'テストを実行する'
    end
    it 'Todoリストを期限付きに変更すると、priorityカラムが更新される' do
      fill_in 'todo_list[deadline]', with: Date.today + 1
      find('.todo-lists__link--update').click
      visit current_path
      expect(todo_list.reload.priority).to eq 0
    end
    it 'Todoリスト編集失敗のテスト' do
      fill_in 'todo_list[body]', with: ''
      find('.todo-lists__link--update').click
      expect(page).to have_selector '.error__message'
    end
    it 'Todoリスト削除のテスト' do
      page.accept_confirm do
        find('.todo-lists__link--destroy').click
      end
      visit current_path
      expect(TodoList.count).to eq 0
    end
    it '「戻る」アイコンをクリックすると編集フォームが非表示になり、Todoリストが表示される' do
      find('.todo-lists__icon--back').click
      expect(page).to have_content todo_list.body
      expect(page).not_to have_selector '.todo-lists__form--edit'
    end
  end

  context 'Todoリストチェックと一覧のテスト' do
    let!(:list) { create(:todo_list, user_id: user.id, goal_id: goal.id) }
    let!(:list_with_deadline) { create(:todo_list, :with_deadline, user_id: user.id, goal_id: goal.id) }
    let!(:list_finished) { create(:todo_list, :finished, user_id: user.id, goal_id: goal.id) }

    before do
      visit current_path
    end

    it '終了していないリストのチェックアイコンにチェックが入っていない' do
      list_1_icon = all('.todo-lists__icon--check')[1]
      list_2_icon = all('.todo-lists__icon--check')[2]
      expect(list_1_icon['alt']).to eq 'checkbox-icon'
      expect(list_2_icon['alt']).to eq 'checkbox-icon'
    end
    it '終了しているリストのチェックアイコンにチェックが入っている' do
      list_3_icon = all('.todo-lists__icon--check')[3]
      expect(list_3_icon['alt']).to eq 'check-icon'
    end
    it '空のチェックボックスをクリックすると、priorityとis_finishedカラムのデータが更新される' do
      # 期限なしのリストにチェックを入れる
      all('.todo-lists__icon--check')[2].click
      expect(list.reload.priority).to eq 2
      expect(list.reload.is_finished).to eq true
    end
    it 'リストへチェックを入れると、表示順が入れ替わっている' do
      # 期限付きのリストにチェックを入れる
      all('.todo-lists__icon--check')[1].click
      # 唯一チェックの入っていないlistのデータが最上部に表示されている
      sleep 1
      expect(all('.js-todo-lists div')[0]).to have_content list.body
    end
    it '期限付きでチェック済みのリストのチェックを外すと、priorityとis_finishedカラムのデータが更新される' do
      # 期限付きのリストにチェックを入れる => 外す
      all('.todo-lists__icon--check')[1].click
      sleep 1
      all('.todo-lists__icon--check')[3].click
      expect(list_with_deadline.reload.priority).to eq 0
      expect(list_with_deadline.reload.is_finished).to eq false
    end
    it '期限なしでチェック済みのリストのチェックを外すと、priorityとis_finishedカラムのデータが更新される' do
      # 終了しているリストのチェックを外す
      all('.todo-lists__icon--check')[3].click
      expect(list_finished.reload.priority).to eq 1
      expect(list_finished.reload.is_finished).to eq false
    end
    it '「チェックずみをさくじょ」ボタンをクリックすると、チェック済みリストが全て削除される' do
      # 全てのリストをチェック済みにする
      all('.todo-lists__icon--check')[2].click
      sleep 1
      all('.todo-lists__icon--check')[1].click
      page.accept_confirm do
        click_on 'チェックずみをさくじょ'
      end
      expect(page).to have_selector '.todo-lists'
      expect(TodoList.count).to eq 0
    end
    it 'Todoリストがpriorityカラムの数値順に並んでいる' do
      # 終了しているリストが3番目に表示されているかチェックボックスから確認
      expect(all('.todo-lists__icon--check')[1]['alt']).to eq 'checkbox-icon'
      expect(all('.todo-lists__icon--check')[2]['alt']).to eq 'checkbox-icon'
      expect(all('.todo-lists__icon--check')[3]['alt']).to eq 'check-icon'
      # 1,2番目の表示内容が正しいか確認
      expect(all('.todo-lists__link--edit')[0]).to have_content list_with_deadline.body
      expect(all('.todo-lists__link--edit')[1]).to have_content list.body
    end
  end

  describe 'Todoリスト検索のテスト' do
    let!(:goal_2) { create(:goal, user_id: user.id) }
    # 目標1に関するTodoリスト
    let!(:list) { create(:todo_list, :list_1, user_id: user.id, goal_id: goal.id) }
    let!(:list_2) { create(:todo_list, :list_2, user_id: user.id, goal_id: goal.id) }
    # 目標2に関するTodoリスト
    let!(:list_3) { create(:todo_list, :list_3, user_id: user.id, goal_id: goal_2.id) }
    let!(:list_4) { create(:todo_list, :list_4, user_id: user.id, goal_id: goal_2.id) }

    before do
      def select_first_goal_category
        within '#goal_category' do
          select goal.category
        end
      end

      def reset_select_box
        within '#goal_category' do
          select 'すべて'
        end
      end

      def reset_text_field
        fill_in 'word', with: ''
      end

      visit current_path
    end

    context 'セレクトボックス単体のテスト' do
      before do
        select_first_goal_category
      end

      it '検索用のセレクトボックスを選択すると、選んだ目標のリストのみ表示される' do
        expect(page).to have_content list.body
        expect(page).to have_content list_2.body
        expect(page).not_to have_content list_3.body
        expect(page).not_to have_content list_4.body
      end
      it '検索用のセレクトボックスを選択後、「すべて」に戻すと全てのリストが表示される' do
        reset_select_box
        expect(page).to have_selector('.todo-lists__link--edit', count: 4)
      end
    end

    context 'フォーム単体のテスト' do
      before do
        fill_in 'word', with: '1つ目の'
      end

      it '検索用フォームに文字を入力すると、本文にその文字が含まれるリストのみ表示される' do
        sleep 1
        # 1つ目という文字列が含まれたリスト1だけ表示されているか
        expect(page).to have_selector('.todo-lists__link--edit', count: 1)
        expect(page).to have_content list.body
      end
      it '入力フォームを空にすると全てのリストが表示される' do
        reset_text_field
        expect(page).to have_selector('.todo-lists__link--edit', count: 4)
      end
    end

    context 'セレクトボックスとフォーム併用時のテスト' do
      before do
        select_first_goal_category
        fill_in 'word', with: '1'
      end

      it '同時に検索ができる' do
        # 目標1かつ1という文字列が含まれたリスト1だけ表示されているか
        expect(page).to have_selector('.todo-lists__link--edit', count: 1)
        expect(page).to have_content list.body
      end
      it 'セレクトボックスを「すべてのもくひょう」に戻すと、フォームの文字でのみ検索され、表示される' do
        reset_select_box
        # 1という文字列が含まれたリスト1,4だけ表示されているか
        expect(page).to have_content list.body
        expect(page).to have_content list_4.body
        expect(page).not_to have_content list_2.body
        expect(page).not_to have_content list_3.body
      end
      it '入力フォームを空にすると、セレクトボックスの目標でのみ検索され、表示される' do
        reset_text_field
        # 目標1に関する投稿である、リスト1,2だけ表示されているか
        expect(page).to have_content list.body
        expect(page).to have_content list_2.body
        expect(page).not_to have_content list_3.body
        expect(page).not_to have_content list_4.body
      end
      it 'セレクトボックスを初期値に戻し、入力フォームを空にすると全てのリストが表示される' do
        reset_select_box
        reset_text_field
        expect(page).to have_selector('.todo-lists__link--edit', count: 4)
      end
    end
  end

  context '期限通知のテスト' do
    let!(:list) { create(:todo_list, :with_deadline, user_id: user.id, goal_id: goal.id) }
    let!(:list_2) { create(:todo_list, :with_deadline, user_id: user.id, goal_id: goal.id, deadline: Date.current + 4) }

    it '期限が3日後の場合、期限が近いという内容の通知が表示される' do
      list.update(deadline: Date.current + 3)
      visit current_path
      expect(page).to have_content 'きげんが近いものが 1 つあります'
    end
    it '期限が2日後の場合、期限が近いという内容の通知が表示される' do
      list.update(deadline: Date.current + 2)
      visit current_path
      expect(page).to have_content 'きげんが近いものが 1 つあります'
    end
    it '期限が翌日の場合、期限が近いという内容の通知が表示される' do
      list.update(deadline: Date.current + 1)
      visit current_path
      expect(page).to have_content 'きげんが近いものが 1 つあります'
    end
    it '期限が当日を除く3日以内のものが複数ある場合、通知に反映される' do
      list.update(deadline: Date.current + 3)
      list_2.update(deadline: Date.current + 2)
      visit current_path
      expect(page).to have_content 'きげんが近いものが 2 つあります'
    end
    it '期限が当日の場合、期限が本日という内容の通知が表示される' do
      list.update(deadline: Date.current)
      visit current_path
      expect(page).to have_content 'きげんが本日のものが 1 つあります'
    end
    it '期限が当日のものが複数ある場合、通知に反映される' do
      list.update(deadline: Date.current)
      list_2.update(deadline: Date.current)
      visit current_path
      expect(page).to have_content 'きげんが本日のものが 2 つあります'
    end
    it '期限が昨日以前の場合、期限超過という内容の通知が表示される' do
      list.deadline = Date.current - 1
      list.save(validate: false)
      visit current_path
      expect(page).to have_content 'きげん切れのものが 1 つあります'
    end
    it '期限が昨日以前のものが複数ある場合、通知に反映される' do
      list.deadline = Date.current - 1
      list.save(validate: false)
      list_2.deadline = Date.current - 1
      list_2.save(validate: false)
      visit current_path
      expect(page).to have_content 'きげん切れのものが 2 つあります'
    end
  end
end
