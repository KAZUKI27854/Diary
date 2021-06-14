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
end