require 'rails_helper'

describe '7.ユーザログイン後のドキュメント関連のテスト', type: :feature, js: true do
  let!(:user) { create(:user) }
  let!(:stage) { create(:stage) }
  let!(:goal) { create(:goal, user_id: user.id, level: 80) }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
  end

  context 'ドキュメント作成のテスト' do
    before do
      click_on 'きろくする'
      within '#document_goal_id' do
        select goal.category
      end
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

    it '画像添付した状態でドキュメント作成ができる' do
      within '#document_add_level' do
        select 10
      end
      attach_file 'document[document_image]', "#{Rails.root}/app/assets/images/character/brave.png"
      click_button 'きろくする'
      expect(page).to have_selector '.levelup__back'
      expect(Document.count).to eq 1
    end
  end
end