require 'rails_helper'

describe '2.ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:goal) { create(:goal, user_id: user.id) }
  let!(:document) { 5.times.collect { |i| create(:document, user_id: user.id, goal_id: goal.id) } }
  let!(:stage) { create(:stage) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ログイン後のヘッダーのテスト' do
      it 'ヘッダーのリンクに「マイページ」がある' do
        expect(page).to have_selector '.head-link-btn', text: 'マイページ'
      end
      it 'マイページの遷移先が現在のユーザのマイページである' do
        head_link = find('.head-link-btn', text: 'マイページ')
        expect(head_link[:href]).to eq user_path(user.id)
      end
      it 'ヘッダーのリンクに「あそびかた」がある' do
        expect(page).to have_selector '.head-link-btn', text: 'あそびかた'
      end
      it 'あそびかたの遷移先がアバウト画面である' do
        head_link = find('.head-link-btn', text: 'あそびかた')
        expect(head_link[:href]).to eq '/about'
      end
      it 'ヘッダーのリンクに「ログアウト」がある' do
        expect(page).to have_selector '.head-link-btn', text: 'ログアウト'
      end
  end

  describe 'ユーザログアウトのテスト' do
    before do
      click_link 'ログアウト'
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトし、リダイレクト先がトップ画面になっている' do
        expect(current_path).to eq root_path
      end
      it 'リダイレクト後のトップ画面とヘッダーに「あたらしくはじめる」リンクが表示されている' do
        top_link = find('.top-link-btn', text: 'あたらしくはじめる')
        expect(top_link[:href]).to eq new_user_registration_path
        head_link = find('.head-link-btn', text: 'あたらしくはじめる')
        expect(head_link[:href]).to eq new_user_registration_path
      end
    end
  end

  describe 'メニュー表示のテスト' do
    context 'メニュー>>しゅじんこうのテスト' do
      it '「なまえ」がユーザの名前と一致する' do
        menu = find('.menu p', text: 'なまえ')
        expect(menu).to have_content user.name
      end
      it '「ステータス」が表示される' do
        expect(page).to have_selector '.user-level', text: 'ステータス'
      end
      it '「ぼうけん」が表示される' do
        expect(page).to have_selector '.doc-count', text: 'ぼうけん'
      end
      it '「クリア」が表示される' do
        expect(page).to have_selector '.menu p', text: 'クリア'
      end
      it '「へんしゅう」のモーダルウインドウへのリンクが表示される' do
        expect(page).to have_selector 'a.js-modal-open', text: 'へんしゅう'
      end
    end

    context 'メニュー>>もくひょうのテスト' do
      it 'ユーザのもくひょうがモーダルウインドウへのリンクとして表示される' do
        expect(page).to have_selector 'a.js-modal-open', text: goal.category
      end
      it 'ユーザのもくひょうに応じた「ステージ」が表示される' do
        expect(page).to have_selector '.menu p', text: stage.name
      end
      it 'ユーザの最新の投稿にある「つぎのもくひょう」が表示される' do
        document = Document.find_by(id: 5)
        expect(page).to have_selector '.menu p', text: document.milestone
      end
      it '「もくひょうせってい」のモーダルウインドウへのリンクが表示される' do
        expect(page).to have_selector 'a.js-modal-open', text: 'せってい'
      end
    end

    context 'メニュー>>きろくするのテスト' do
      it '新規投稿のモーダルウインドウへのリンクが表示される' do
        expect(page).to have_selector 'a.js-modal-open', text: 'きろくする'
      end
    end
  end

  describe '投稿一覧のテスト' do
    context '表示件数のテスト' do
      it '1ページに表示されるのが4件である' do
        expect(all('.doc-card').size).to eq(4)
      end
    end

    context '投稿文のテスト' do
      it 'bodyの冒頭に、「目標のカテゴリー名+ダンジョン」が表示される' do
        expect(page).to have_selector '.doc-title', text: goal.category + 'のダンジョン'
      end
      it 'bodyの末尾に、「ユーザ名+documentごとのadd_level+レベルアップした」という文が表示される' do
        expect(page).to have_selector '.doc-body', text: user.name + 'は ' + '1 レベルアップした'
      end
      it 'bodyの末尾に、【つぎのもくひょう】というテキストとdocumentごとのmilestoneが表示される' do
        expect(page).to have_selector '.doc-body', text: '【つぎのもくひょう】'
        documents = Document.where(id: 1..4)
        documents.each do |document|
          expect(page).to have_selector '.doc-body', text: document.milestone
        end
      end
    end

    context '100番目までの投稿のテスト' do
      xit '投稿回数が5の倍数の時、ボスモンスターが表示される' do
        #document = Document.find_by(id: 5)
        #img = find_all('.monster-img')[9]
        #img = find('.monster-img')
        #card = find_all('.doc-card')[1]
        #expect(card).to have_css '.monster-img'
        expect(page).to have_selector ("img[src='/assets/monster/boss1.png']")

      end
    end
  end


end