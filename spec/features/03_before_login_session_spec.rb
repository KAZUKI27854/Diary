require 'rails_helper'

describe '3.ユーザログイン前のログイン画面のテスト', type: :feature do
  let!(:user) { create(:user) }

  before do
    visit new_user_session_path
  end

  context '表示内容の確認' do
    it '「かみのごかごがあらんことを」と表示される' do
      expect(page).to have_content 'かみのごかごがあらんことを'
    end
    it 'メッセージキャラが神父である' do
      expect(page).to have_css '.father'
    end
    it 'メールフォームが表示される' do
      expect(page).to have_field 'user[email]'
    end
    it 'パスワードフォームが表示される' do
      expect(page).to have_field 'user[password]'
    end
    it 'ログインボタンが表示される' do
      expect(page).to have_button 'ログイン'
    end
    it 'なまえフォームは表示されない' do
      expect(page).not_to have_field 'user[name]'
    end
  end

  context 'リンクのテスト' do
    it '新規登録リンクが表示される' do
      expect(page).to have_link 'しんきとうろく'
    end
    it 'パスワード変更リンクが表示される' do
      expect(page).to have_link 'パスワードをおわすれですか'
    end
    it 'GoogleのOAuth認証のリンクが表示される' do
      expect(page).to have_link 'GoogleOauth2でログインする'
    end
    it 'FacebookのOAuth認証のリンクが表示される' do
      expect(page).to have_link 'Facebookでログインする'
    end
    it 'TwitterのOAuth認証のリンクが表示される' do
      expect(page).to have_link 'Twitterでログインする'
    end
  end

  context 'ログイン成功のテスト' do
    before do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    it 'ログイン後のリダイレクト先がマイページである' do
      expect(current_path).to eq my_page_path
    end
    it 'ログイン時に「ログインしました」というフラッシュメッセージが表示される' do
      expect(page).to have_content 'ログインしました'
    end
  end

  context 'ログイン失敗のテスト' do
    before do
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      click_button 'ログイン'
    end

    it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
      expect(current_path).to eq new_user_session_path
    end
    it 'ログイン失敗時にエラーメッセージが表示される' do
      expect(page).to have_content 'メールアドレスまたはパスワードが違います'
    end
  end
end
