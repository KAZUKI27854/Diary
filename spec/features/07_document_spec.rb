require 'rails_helper'

describe '7.ユーザログイン後のドキュメント関連のテスト', type: :feature, js: true do
  let!(:user) { create(:user) }
  let!(:stage) { create(:stage) }
  let!(:goal) { create(:goal, user_id: user.id, level: 80) }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
  end

  context 'ドキュメント作成成功のテスト' do
    before do
      click_link 'きろくする'

      within '#document_goal_id' do
        select goal.category
      end
      attach_file 'document[document_image]', "#{Rails.root}/app/assets/images/character/brave.png"
      fill_in 'document[body]', with: 'テスト'
      fill_in 'document[milestone]', with: 'テスト成功'
    end

    it 'メニューの「きろくする」をクリックすると、ドキュメント作成モーダルが表示される' do
      expect(page).to have_selector "#modal-new-doc"
    end

    it 'ドキュメント作成成功のテスト（目標レベル100以下の場合）' do
      within '#document_add_level' do
        select 10
      end
      click_button 'きろくする'

      expect(page).to have_selector '.levelup__back'
      expect(Document.count).to eq 1
    end

    it '目標レベルが初めて100を越えた場合、投稿後のフラッシュ演出が変化している' do
      within '#document_add_level' do
        select 20
      end
      click_button 'きろくする'

      expect(page).to have_selector '.clear__back'
      expect(Document.count).to eq 1
    end
  end

  it 'ドキュメント作成失敗のテスト' do
    click_link 'きろくする'

    fill_in 'document[body]', with: ''
    fill_in 'document[milestone]', with: ''
    click_button 'きろくする'

    expect(page).to have_selector '.error__message'
    expect(Document.count).to eq 0
  end

  context 'ドキュメント編集成功のテスト' do
    let!(:goal) { create(:goal, user_id: user.id, level: 10, doc_count:1) }
    let!(:document) { create(:document, user_id: user.id, goal_id: goal.id, add_level: 10) }

    let!(:second_goal) { create(:goal, user_id: user.id, level: 5, doc_count:1) }
    let!(:second_document) { create(:document, user_id: user.id, goal_id: second_goal.id, add_level: 5) }

    before do
      visit '/documents/1/edit'

      attach_file 'document[document_image]', "#{Rails.root}/app/assets/images/character/brave.png"
      fill_in 'document[body]', with: 'テスト'
      fill_in 'document[milestone]', with: 'テスト成功'
      within '#document_add_level' do
        select 20
      end
    end

    it 'ドキュメントの目標以外の項目が変更できる' do
      click_button 'きろくしなおす'

      expect(current_path).to eq my_page_path
      expect(page).to have_content 'きろくをへんこうしました'

      expect([document.reload.document_image_id]).to be_present
      expect(document.reload.body).to eq 'テスト'
      expect(document.reload.milestone).to eq 'テスト成功'
      expect(document.reload.add_level).to eq 20
    end

    it 'ドキュメントの目標を変更すると、変更前と後の目標のレベルや投稿数も変更される' do
      within '#document_goal_id' do
        select second_goal.category
      end
      click_button 'きろくしなおす'

      expect(page).to have_content 'きろくをへんこうしました'

      #変更前の目標データが変わっているか
      expect(goal.reload.level).to eq 0
      expect(goal.reload.doc_count).to eq 0

      #変更後の目標データが変わっているか
      expect(second_goal.reload.level).to eq 25
      expect(second_goal.reload.doc_count).to eq 2
    end
  end

  context 'ドキュメント編集失敗のテスト' do
    let!(:goal) { create(:goal, user_id: user.id, level: 10, doc_count:1) }
    let!(:document) { create(:document, body: 'テスト', user_id: user.id, goal_id: goal.id, add_level: 10) }

    before do
      visit '/documents/1/edit'

      fill_in 'document[body]', with: ''
      fill_in 'document[milestone]', with: ''
      click_button 'きろくしなおす'
    end

    it '入力値が空のものがある場合、エラーメッセージが表示される' do
      expect(page).to have_selector '.error__message'
    end

    it 'ドキュメント編集に失敗している' do
      expect(document.reload.body).to eq 'テスト'
    end
  end

  context 'ドキュメント削除のテスト' do
    let!(:goal) { create(:goal, user_id: user.id, level: 10, doc_count:1) }
    let!(:document) { create(:document, user_id: user.id, goal_id: goal.id, add_level: 10) }

    before do
      visit my_page_path
      page.accept_confirm do
        find('.doc-card__icon--delete').click
      end
    end

    it 'ドキュメントが削除され、フラッシュメッセージが表示されている' do
      expect(page).to have_content 'きろくをさくじょしました'
      expect(Document.count).to eq 0
    end

    it 'マイページにリダイレクトされている' do
      expect(current_path).to eq my_page_path
    end

    it '削除したドキュメントに関連する目標データが更新されている' do
      expect(page).to have_content 'きろくをさくじょしました'
      expect(goal.reload.level).to eq 0
      expect(goal.reload.doc_count).to eq 0
    end
  end

  describe 'ドキュメント検索のテスト' do
    let!(:document) { create(:document, user_id: user.id, goal_id: goal.id, body: '1つ目のドキュメント') }

    let!(:second_goal) { create(:goal, user_id: user.id) }
    let!(:second_document) { create(:document, user_id: user.id, goal_id: second_goal.id, body: '2つ目のドキュメント') }

    let!(:third_document) { create(:document, user_id: user.id, goal_id: goal.id, body: '3つ目のドキュメント') }

    before do
      def expect_all_doc_exist
        expect(page).to have_content document.body
        expect(page).to have_content second_document.body
        expect(page).to have_content third_document.body
      end

      def expect_only_first_doc_exist
        expect(page).to have_content document.body
        expect(page).not_to have_content second_document.body
        expect(page).not_to have_content third_document.body
      end

      def select_first_goal_category
        within '#doc_goal_category' do
          select goal.category
        end
      end

      def fill_in_number_one
        fill_in 'doc_word', with: '1'
      end

      def reset_select_box
        within '#doc_goal_category' do
          select 'すべてのもくひょう'
        end
      end

      def reset_text_field
        fill_in 'doc_word', with: ''
      end

      visit current_path
    end

    context 'セレクトボックス単体のテスト' do
      before do
        select_first_goal_category
      end

      it '検索用のセレクトボックスを選択すると、選んだ目標のドキュメントのみ表示される' do
        expect(page).to have_content document.body
        expect(page).to have_content third_document.body

        expect(page).not_to have_content second_document.body
      end

      it '検索用のセレクトボックスを選択後、「すべてのもくひょう」に戻すと全てのドキュメントが表示される' do
        reset_select_box
        expect_all_doc_exist
      end
    end

    context 'フォーム単体のテスト' do
      before do
        fill_in_number_one
      end

      it '検索用フォームに文字を入力すると、本文にその文字が含まれるドキュメントのみ表示される' do
        expect_only_first_doc_exist
      end

      it '入力フォームを空にすると全てのドキュメントが表示される' do
        reset_text_field
        expect_all_doc_exist
      end
    end

    context 'セレクトボックスとフォーム併用時のテスト' do
      #目標1に関する投稿 => ドキュメント1,3
      #目標2に関する投稿 => ドキュメント2,4
      let!(:fourth_document) { create(:document, user_id: user.id, goal_id: second_goal.id, body: '1時間運動した') }

      before do
        select_first_goal_category
        fill_in_number_one
      end

      it '同時に検索ができる' do
        expect_only_first_doc_exist
      end

      it 'セレクトボックスを「すべてのもくひょう」に戻すと、フォームの文字でのみ検索され、表示される' do
        reset_select_box

        #1という文字列が含まれたドキュメント1,4だけ表示されているか
        expect_only_first_doc_exist
        expect(page).to have_content fourth_document.body
      end

      it '入力フォームを空にすると、セレクトボックスの目標でのみ検索され、表示される' do
        reset_text_field

        #目標1に関する投稿である、ドキュメント1,3だけ表示されているか
        expect(page).to have_content document.body
        expect(page).to have_content third_document.body

        expect(page).not_to have_content second_document.body
        expect(page).not_to have_content fourth_document.body
      end

      it 'セレクトボックスを初期値に戻し、入力フォームを空にすると全てのドキュメントが表示される' do
        reset_select_box
        reset_text_field

        expect_all_doc_exist
        expect(page).to have_content fourth_document.body
      end
    end
  end
end