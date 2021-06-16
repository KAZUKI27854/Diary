require 'rails_helper'

describe '1.ユーザログイン前のトップ画面のテスト', type: :feature do
  before do
    visit root_path
  end

  context 'ヘッダーの確認', js: true do
    before do
      click_on 'MENU'
    end

    it 'ヘッダーのリンクに「あそびかた」がある' do
      expect(page).to have_link 'あそびかた'
    end
    it 'あそびかたの遷移先がアバウト画面である' do
      click_on 'あそびかた'
      expect(current_path).to eq '/about'
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

  context 'トップ画面のリンクの確認' do
    #ヘッダーとリンク名が重複しているものは、クラスとテキストでリンクを指定
    it '画面内のリンクに「あたらしくはじめる」がある' do
      expect(page).to have_selector '.top__link', text: 'あたらしくはじめる'
    end
    it '「あたらしくはじめる」リンクの遷移先が新規登録画面である' do
      link = find('.top__link', text: 'あたらしくはじめる')
      expect(link[:href]).to eq new_user_registration_path
    end
    it '画面内のリンクに「つづきから」がある' do
      expect(page).to have_selector '.top__link', text: 'つづきから'
    end
    it '「つづきから」リンクの遷移先がログイン画面である' do
      link = find('.top__link', text: 'つづきから')
      expect(link[:href]).to eq new_user_session_path
    end
    it '画面内のリンクに「ゲストログイン」がある' do
      expect(page).to have_link 'ゲストログイン'
    end
  end

  context 'トップ画面からのゲストログインの確認' do
    before do
      click_on 'ゲストログイン'
    end

    it '遷移先がゲストのマイページである' do
      expect(current_path).to eq my_page_path
    end
    it '遷移後に「ゲストでログインしました」というフラッシュが表示される' do
      expect(page).to have_content('ゲストでログインしました')
    end
    it 'ゲストユーザーとしてログインしている' do
      guest_user = User.first
      expect(guest_user.email).to eq 'guest@example.com'
    end
  end

  context 'アバウト画面のリンクの確認' do
    it '画面内のリンクに「はじめてとうろくする方」がある' do
      expect(page).to have_link 'はじめてとうろくする方'
    end
    it '「はじめてとうろくする方」リンクの遷移先が新規登録画面である' do
      click_on 'はじめてとうろくする方'
      expect(current_path).to eq new_user_registration_path
    end
    it '画面内のリンクに「すでにとうろく済みの方」がある' do
      expect(page).to have_link 'すでにとうろく済みの方'
    end
    it '「すでにとうろく済みの方」リンクの遷移先がログイン画面である' do
      click_on 'すでにとうろく済みの方'
      expect(current_path).to eq new_user_session_path
    end
    it '画面内のリンクに「すでにとうろく済みの方」がある' do
      expect(page).to have_link 'ゲストユーザーでお試し'
    end
  end

  context 'アバウト画面からのゲストログインの確認' do
    before do
      click_on 'ゲストユーザーでお試し'
    end

    it '遷移先がゲストのマイページである' do
      expect(current_path).to eq my_page_path
    end
    it '遷移後に「ゲストでログインしました」というフラッシュが表示される' do
      expect(page).to have_content('ゲストでログインしました')
    end
    it 'ゲストユーザーとしてログインしている' do
      guest_user = User.first
      expect(guest_user.email).to eq 'guest@example.com'
    end
  end
end