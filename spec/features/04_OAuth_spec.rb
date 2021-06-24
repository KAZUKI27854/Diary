require 'rails_helper'

describe '4.OAuth認証のテスト（Googleのみ）', type: :feature do
  # Facebook,Twitterは本番環境でのみ導入しているため割愛
  before do
    visit new_user_registration_path
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => "google_oauth2",
      "uid" => "123456",
      "info" => {
        "email" => "test@example.com",
      },
    })
    click_on 'GoogleOauth2でログインする'
  end

  context 'OAuth認証による新規登録のテスト' do
    it 'GoogleOauth2認証による新規登録が成功する' do
      expect(User.count).to eq 1
    end
    it 'OAuth認証後のリダイレクト先がマイページである' do
      expect(current_path).to eq my_page_path
    end
    it 'OAuth認証時に「googleアカウントでログインしました」というフラッシュが表示される' do
      expect(page).to have_content 'googleアカウントでログインしました'
    end
  end

  context 'OAuth認証によるログインのテスト' do
    before do
      visit new_user_session_path
      click_on 'GoogleOauth2でログインする'
    end

    it 'OAuth認証済みのアカウントでログインできる' do
      expect(current_path).to eq my_page_path
    end
    it 'ログイン後に「googleアカウントでログインしました」というフラッシュが表示される' do
      expect(page).to have_content 'googleアカウントでログインしました'
    end
    it '新しいユーザーが作成されていない' do
      expect(User.count).to eq 1
    end
  end
end
