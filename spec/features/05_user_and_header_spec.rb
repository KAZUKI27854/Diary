require 'rails_helper'

describe '5.ユーザログイン後のヘッダーとユーザーメニューのテスト', type: :feature, js: true do
  let!(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
  end

  context 'ヘッダーの確認' do
    before do
      click_on 'MENU'
    end

    it 'ヘッダーのリンクに「マイページ」がある' do
      expect(page).to have_link 'マイページ'
    end

    it '「マイページ」リンクの遷移先がマイページである' do
      click_on 'マイページ'
      expect(current_path).to eq my_page_path
    end

    it 'ヘッダーのリンクに「あそびかた」がある' do
      expect(page).to have_link 'あそびかた'
    end

    it '「あそびかた」リンクの遷移先がチュートリアル画面である' do
      click_on 'あそびかた'
      expect(current_path).to eq '/tutorial'
    end

    it 'ヘッダーのリンクに「ログアウト」がある' do
      expect(page).to have_link 'ログアウト'
    end

    it 'ログアウトの遷移先がトップ画面である' do
      click_on 'ログアウト'
      expect(current_path).to eq root_path
    end

    it 'ヘッダーのリンクに「プライバシーポリシー」がある' do
      expect(page).to have_link 'プライバシーポリシー'
    end

    it 'プライバシーポリシーの遷移先がプライバシーポリシー画面である' do
      click_on 'プライバシーポリシー'
      expect(current_path).to eq policy_path
    end
  end

  describe 'メニュー画面の非表示確認テスト' do
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

    context '表示のテスト' do
      let!(:goal) { create(:goal, user_id: user.id, level: 100) }

      before do
        create_list(:document, 5, user_id: user.id, goal_id: goal.id)
        visit current_path
        all('.my-page__menu--icon')[0].click
      end

      it 'ユーザーアイコンをクリックするとユーザーメニューが表示される' do
        expect(page).to have_selector '.my-page__menu'
      end

      it 'ユーザーメニューに表示されている名前が正しい' do
        expect(page).to have_content 'なまえ: ' + user.name
      end

      it 'ぼうけんの回数がドキュメントの数と一致している' do
        expect(page).to have_content 'ぼうけん: ' + user.documents.count.to_s + ' 回'
      end

      it 'クリア回数が、レベル100以上の目標の数と一致している' do
        clear_goals = user.goals.where("level >= ?", 100)
        expect(page).to have_content 'クリア: ' + clear_goals.count.to_s + ' 回'
      end
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

      it 'ユーザー編集成功のテスト' do
        fill_in 'user[name]', with: 'テストユーザー'
        attach_file 'user[profile_image]', "#{Rails.root}/app/assets/images/character/brave.png"
        click_button 'へんこう'
        expect(page).to have_content 'データをへんこうしました'
        expect(user.reload.name).to eq 'テストユーザー'
        expect([user.profile_image_id]).to be_present
      end

      it 'ユーザー編集失敗のテスト' do
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

      it '退会確認画面で「退会する」をクリックするとユーザーが論理削除される' do
        page.accept_confirm do
          click_on '退会する'
        end
        visit my_page_path
        expect(current_path).to eq root_path
        expect(user.reload.is_active).to eq false
      end

      it '退会済みユーザーの情報でログインするとエラーメッセージが表示され、ログインできない' do
        page.accept_confirm do
          click_on '退会する'
        end
        visit my_page_path
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        expect(page).to have_content 'このアカウントは退会済みです'
        expect(current_path).to eq new_user_session_path
      end
    end

    context 'ゲストユーザーの退会バリデーションテスト' do
      before do
        # 通常ユーザーとしてログアウト後、ゲストログイン
        click_on 'MENU'
        click_on 'ログアウト'
        click_on 'MENU'
        all('.header__link')[4].click

        # マイページ退会するまで
        all('.my-page__menu--icon')[0].click
        click_on 'へんしゅう'
        click_on '退会する'
        page.accept_confirm do
          click_on '退会する'
        end
      end

      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'ゲストはさくじょできません'
      end

      it 'バリデーションチェック後の遷移先がマイページである' do
        expect(current_path).to eq my_page_path
      end

      it 'ゲストユーザーデータが論理削除されていない' do
        guest_user = User.find_by(email: 'guest@example.com')
        expect(guest_user.is_active).to eq true
      end
    end
  end
end
