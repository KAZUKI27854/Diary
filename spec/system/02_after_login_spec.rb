require 'rails_helper'

describe '2.ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:goal) { create(:goal, user_id: user.id) }
  let!(:document) { create(:document, user_id: user.id, goal_id: goal.id) }
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
      it 'ユーザの「つぎのもくひょう」が表示される' do
        expect(page).to have_selector '.menu p', text: document.milestone
      end
      it '「もくひょうせってい」のモーダルウインドウへのリンクが表示される' do
        expect(page).to have_selector 'a.js-modal-open', text: 'せってい'
      end
    end

    context 'メニュー>>きろくするのテスト' do
      before do
        find("#document_goal_id").find("option[value='1']").select_option
        fill_in "#document_body", with: Faker::Games::Zelda.game
        fill_in "#document_milestone", with: Faker::Games::Zelda.location
        #select(value="1", from: document[add_level])
        find("#document_add_level").find("option[value='1']").select_option
      end

      it 'ユーザの新しい投稿が正しく保存される' do
        expect { click_button 'きろくする' }.to change(user.document, :count).by(1)
      end
      it 'リダイレクト先がマイページになっている' do
        click_button 'きろくする'
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end


end