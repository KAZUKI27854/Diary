require 'rails_helper'

describe '2.ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:goal) { 5.times.collect { |i| create(:goal, user_id: user.id) } }
  let!(:document) { 5.times.collect { |i| create(:document, user_id: user.id, goal_id: Goal.find(5).id) } }
  let!(:stage) { 2.times.collect { |i| create(:stage) } }

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
        goals = Goal.where(id: 2..5)
        goals.each do |goal|
          expect(page).to have_selector 'a.js-modal-open', text: goal.category
        end
      end
      it '更新順で数えて5つ目以降のもくひょうは表示されない' do
        goal = Goal.find(1)
        expect(page).not_to have_selector 'a.js-modal-open', text: goal.category
      end
      it 'ユーザのもくひょうに応じた「ステージ」が表示される' do
        stage = Stage.find(1)
        4.times do |i|
          expect(page).to have_selector '.menu p', text: stage.name
        end
      end
      it '投稿があるもくひょうに最新の「つぎのもくひょう」が表示される' do
        document = Document.last
        expect(page).to have_selector '.menu p', text: document.milestone
      end
      it '投稿がないもくひょうには「ぼうけんをきろくする」というリンクが表示される' do
        3.times do |i|
          expect(page).to have_link 'ぼうけんをきろくする'
        end
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
      it '1ページに表示される投稿が4件である' do
        expect(all('.doc-card').size).to eq(4)
      end
    end

    context '投稿文のテスト' do
      it 'bodyの冒頭に、「目標のカテゴリー名+ダンジョン」が表示される' do
        goal = Goal.find(5)
        expect(page).to have_selector '.doc-title', text: goal.category + 'のダンジョン'
      end
      it 'bodyに、「ユーザ名+documentごとのadd_level+レベルアップした」という文が表示される' do
        expect(page).to have_selector '.doc-body', text: user.name + 'は ' + '1 レベルアップした'
      end
      it 'bodyに、【つぎのもくひょう】というテキストとdocumentごとのmilestoneが表示される' do
        documents = Document.where(id: 2..5)
        documents.each do |document|
          expect(page).to have_selector '.doc-body', text: '【つぎのもくひょう】'
          expect(page).to have_selector '.doc-body', text: document.milestone
        end
      end
      it '「へんしゅう」リンクがある' do
        expect(page).to have_link 'へんしゅう'
      end
      it '「さくじょ」リンクがある' do
        expect(page).to have_link 'さくじょ'
      end
      it '削除の前に「削除してよろしいですか？」という確認がある' do
        delete_link = find_all('.delete_link').first
        expect(delete_link['data-confirm']).to eq '削除してよろしいですか？'
      end
    end

    context '画像のテスト' do
      it '投稿回数が5の倍数の時、ボスモンスターが表示される' do
        card = find_all('.doc-card').first
        expect(card).to have_selector 'div[class=boss-monster]'
      end
      it '投稿回数が5の倍数の時、モンスター2体は表示されない' do
        card = find_all('.doc-card').first
        expect(card).not_to have_selector 'div[class=monster-left], div[class=monster-right]'
      end
      it '投稿回数が5の倍数でない時、モンスターが２体表示される' do
        card = find_all('.doc-card')[1]
        expect(card).to have_selector 'div[class=monster-left], div[class=monster-right]'
      end
      it '投稿回数が5の倍数でない時、ボスモンスターは表示されない' do
        card = find_all('.doc-card')[1]
        expect(card).not_to have_selector 'div[class=boss-monster]'
      end
    end

    context '画像のテスト(投稿回数6回以上）' do
      before do
        create(:document, user_id: user.id, goal_id: Goal.find(5).id)
        visit user_path(user.id)
      end
      it '投稿回数が「5n + 1」回の時、ステージ画像が変わっている(6回目の投稿時にステージ2の画像か)' do
        card = find_all('.doc-card').first
        expect(card).to have_selector "img[src$='stage2.jpg']"
        expect(card).not_to have_selector "img[src$='stage1.jpg']"
      end
    end
  end


end