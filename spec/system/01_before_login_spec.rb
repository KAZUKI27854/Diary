require 'rails_helper'

describe '1.ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context 'URLとヘッダーの確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ヘッダーのリンクに「あそびかた」がある' do
        expect(page).to have_selector '.head-link-btn', text: 'あそびかた'
      end
      it 'あそびかたの遷移先がアバウト画面である' do
        head_link = find('.head-link-btn', text: 'あそびかた')
        expect(head_link[:href]).to eq '/about'
      end
      it 'ヘッダーのリンクに「あたらしくはじめる」がある' do
        expect(page).to have_selector '.head-link-btn', text: 'あたらしくはじめる'
      end
      it 'あたらしくはじめるの遷移先が新規登録画面である' do
        head_link = find('.head-link-btn', text: 'あたらしくはじめる')
        expect(head_link[:href]).to eq new_user_registration_path
      end
      it 'ヘッダーのリンクに「つづきから」がある' do
        expect(page).to have_selector '.head-link-btn', text: 'つづきから'
      end
      it 'つづきからの遷移先が新規登録画面である' do
        head_link = find('.head-link-btn', text: 'つづきから')
        expect(head_link[:href]).to eq new_user_session_path
      end
    end

    context 'bodyのリンクの確認' do
      it '画面内のリンクに「あたらしくはじめる」がある' do
        expect(page).to have_selector '.top-link-btn', text: 'あたらしくはじめる'
      end
      it 'あたらしくはじめるの遷移先が新規登録画面である' do
        top_link = find('.top-link-btn', text: 'あたらしくはじめる')
        expect(top_link[:href]).to eq new_user_registration_path
      end
      it '画面内のリンクに「つづきから」がある' do
        expect(page).to have_selector '.top-link-btn', text: 'つづきから'
      end
      it 'つづきからの遷移先が新規登録画面である' do
        top_link = find('.top-link-btn', text: 'つづきから')
        expect(top_link[:href]).to eq new_user_session_path
      end
    end

    context 'ゲストログインの確認' do
      it '画面内のリンクに「ゲストログイン」がある' do
        expect(page).to have_selector '.guest-link', text: 'ゲストログイン'
      end
      it 'ゲストログインの遷移先がゲストのマイページである' do
        click_on 'ゲストログイン'
        expect(current_path).to eq '/users/1'
      end
      it 'ゲストログイン時に「ゲストでログインしました」というフラッシュが表示される' do
        click_link 'ゲストログイン'
        expect(page).to have_selector '.notice-message', text: 'ゲストでログインしました'
      end
    end

  end
  describe '新規登録画面のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
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
      it '新規登録後のリダイレクト先が、そのユーザのマイページである' do
        click_button 'とうろく'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
      it '新規登録時に「アカウントを作成しました」というフラッシュが表示される' do
        click_button 'とうろく'
        expect(page).to have_selector '.notice-message', text: 'アカウントを作成しました'
      end
    end

    context '新規登録失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button 'とうろく'
      end

      it '新規登録に失敗し、エラーメッセージが表示される' do
        expect(page).to have_css '.error-explanation'
      end
    end
  end

  describe 'ログイン画面のテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
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


    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザのマイページになっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
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
    end

  end

end

