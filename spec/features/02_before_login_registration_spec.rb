require 'rails_helper'

describe '2.ユーザログイン前の新規登録画面のテスト', type: :feature do
  before do
    visit new_user_registration_path
  end

  context 'URLとフォーム内容のテスト' do
    it '「ぼうけんのはじまりじゃ」と表示される' do
      expect(page).to have_content 'ぼうけんのはじまりじゃ'
    end

    it 'メッセージキャラが老師である' do
      expect(page).to have_css '.master'
    end

    it 'なまえのフォームが表示される' do
      expect(page).to have_field 'user[name]'
    end

    it 'メールフォームが表示される' do
      expect(page).to have_field 'user[email]'
    end

    it 'パスワードフォームが表示される' do
      expect(page).to have_field 'user[password]'
    end

    it 'かくにんようパスワードフォームが表示される' do
      expect(page).to have_field 'user[password_confirmation]'
    end

    it 'とうろくボタンが表示される' do
      expect(page).to have_button 'とうろく'
    end
  end

  context 'リンクのテスト' do
    it 'ログインリンクが表示される' do
      expect(page).to have_link 'ログイン'
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

  context '新規登録成功のテスト' do
    before do
      fill_in 'user[name]', with: Faker::Games::Pokemon.name
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    it '正しく新規登録される' do
      expect { click_button 'とうろく' }.to change(User.all, :count).by(1)
    end

    it '新規登録後のリダイレクト先がマイページである' do
      click_button 'とうろく'
      expect(current_path).to eq my_page_path
    end

    it '新規登録時に「アカウントを作成しました」というフラッシュが表示される' do
      click_button 'とうろく'
      expect(page).to have_content 'アカウントを作成しました'
    end
  end

  context '新規登録失敗のテスト' do
    before do
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
    end

    it '新規登録に失敗している' do
      expect(User.all.count).to be 0
    end

    it 'エラーメッセージが表示される' do
      click_button 'とうろく'
      expect(page).to have_selector '.error__message'
    end
  end
end
