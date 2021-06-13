require 'rails_helper'

describe '5.ユーザログイン後のマイページのテスト', type: :feature, js: true do
  let!(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
  end

  describe '非表示確認テスト' do
    it '全てのモーダルウインドウが非表示になっている' do
      expect(page).not_to have_selector '.modal'
    end
    it 'ユーザーと目標のメニューが非表示になっている' do
      expect(page).not_to have_selector '.my-page__menu'
    end
  end

  describe 'ユーザーメニューのテスト' do
    before do
      all('.my-page__menu--icon')[0].click
    end

    it 'ユーザーアイコンをクリックするとユーザーメニューが表示される' do
      expect(page).to have_selector '.my-page__menu'
      expect(page).to have_content 'なまえ'
    end

    context 'ユーザー編集モーダルのテスト' do
      before do
        click_on 'へんしゅう'
      end

      it '「へんしゅう」をクリックするとユーザー編集のモーダルが表示される' do
        expect(page).to have_selector '#modal-user-edit'
      end
      it '名前のフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'プロフィール画像のフォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      xit '名前とプロフィール画像の変更が成功する' do
        fill_in 'user[name]', with: 'テストユーザー'
        click_button 'へんこう'
        expect(page).to have_content 'データをへんこうしました'
        #attach_file 'user[profile_image]', "#{Rails.root}/app/assets/images/character/brave.png"
        #expect{ click_on 'へんこう' }.to change{ user.name }.to('テストユーザー')
        expect(user.name).to be 'テストユーザー'
        expect([user.profile_image_id]).to be_present
      end
      it 'エラーメッセージが正しく表示される' do
        fill_in 'user[name]', with: ''
        click_button 'へんこう'
        expect(page).to have_selector '.error__message'
      end
    end

    context '退会確認モーダルのテスト' do
      before do
        click_on 'へんしゅう'
        click_on '退会する'
      end
      it 'ユーザー編集モーダルで「退会する」をクリックすると退会確認画面へ遷移する' do
        expect(page).to have_selector '.withdraw-confirm'
      end
      it '「もどる」をクリックするとユーザー編集画面へ切り替わる' do
        click_on 'もどる'
        expect(page).to have_selector '#modal-user-edit'
        expect(page).not_to have_selector '.withdraw-confirm'
      end
      xit '退会確認画面で「退会する」をクリックするとユーザーが論理削除される' do
        click_on '退会する'
        page.driver.browser.switch_to.alert.accept
        # page.accept_confirm do
        #   click_on '退会する'
        # end
        expect(current_path).to eq root_path
        expect(User.first.is_active).to be false
        #expect{ page.driver.browser.switch_to.alert.accept }.to change{ User.first.is_active }.from(true).to(false)
      end
      xit '退会済みユーザーの情報でログインするとエラーメッセージが表示され、ログインできない' do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        expect(page).to have_content 'このアカウントは退会済みです'
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe '目標データ作成前のテスト' do
    it 'メニューの目標アイコンにバウンドアニメーションの為のクラスが追加されている', js: true do
      goal_icon = find '.my-page__menu--icon--goal'
      expect(goal_icon['class']).to include 'js-bound'
    end

    xit 'ドキュメント作成モーダルへのリンクが無効化されている', js: true do
      #find('.js-save-link').click
      expect( find('.js-save-link').click ).to raise_error
      #expect(find('#modal-new-doc', visible: false)).to_not be_visible
      #expect(page).not_to have_selector '.new-doc'
      #expect(page).to have_no_content 'ぼうけんをきろくできるぞ'
      # binding.irb
    end

    it 'サイドメニューの目標アイコンから目標設定のモーダルが表示できる', js: true do

    end
  end
end