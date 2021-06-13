require 'rails_helper'

describe '5.ユーザログイン後のメニュー画面のテスト', type: :feature, js: true do
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

  describe '目標作成前の目標メニューのテスト' do
    let!(:stage) { create(:stage) }

    before do
      all('.my-page__menu--icon')[1].click
    end

    it '目標アイコンにバウンドアニメーションの為のクラスが追加されている' do
      goal_icon = find '.my-page__menu--icon--goal'
      expect(goal_icon['class']).to include 'js-bound'
    end

    it '目標アイコンをクリックすると目標メニューが表示される' do
      expect(page).to have_selector '.my-page__menu'
      expect(page).to have_content 'せっていする'
    end

    context '目標作成モーダルのテスト' do
      before do
        click_on 'せっていする'
      end

      it '目標メニューの「せっていする」をクリックすると目標作成モーダルが表示される' do
        expect(page).to have_selector '#modal-new-goal'
      end
      it 'カテゴリー入力フォームが表示される' do
        expect(page).to have_field 'goal[category]'
      end
      it '最終目標入力フォームが表示される' do
        expect(page).to have_field 'goal[goal_status]'
      end
      it '目標期限入力フォームが表示される' do
        expect(page).to have_field 'goal[deadline]'
      end
      it '目標作成成功のテスト' do
        fill_in 'goal[category]', with: Faker::Games::Pokemon.move
        fill_in 'goal[goal_status]', with: Faker::Games::Pokemon.move
        fill_in 'goal[deadline]', with: Faker::Date.in_date_period
        expect{ click_on 'せってい' }.to change{ Goal.count }.by(1)
        expect(page).to have_content 'もくひょうをついかしました'
      end
      it '目標作成失敗のテスト' do
        fill_in 'goal[category]', with: ''
        fill_in 'goal[goal_status]', with: ''
        fill_in 'goal[deadline]', with: ''
        expect{ click_on 'せってい' }.to change{ Goal.count }.by(0)
        expect(page).to have_selector '.error__message'
      end
    end
  end

  describe '目標作成後の目標メニューのテスト' do
    let!(:stage) { create(:stage) }
    let!(:goal) { create(:goal, user_id: user.id) }

    before do
      #通常であれば目標作成後にマイページへリダイレクトされる為
      visit my_page_path
      all('.my-page__menu--icon')[1].click
    end

    it '目標アイコンにバウンドアニメーションの為のクラスがない' do
      goal_icon = find '.my-page__menu--icon--goal'
      expect(goal_icon['class']).not_to include 'js-bound'
    end
    it '目標メニューに設定した目標のカテゴリーが表示されている' do
      expect(page).to have_content goal.category
    end
    it '設定した目標の、次の目標が「ぼうけんをきろくする」になっている' do
      expect(page).to have_content 'ぼうけんをきろくする'
    end
    it '「ぼうけんをきろくする」をクリックすると、ドキュメント作成モーダルが表示される' do
      click_on 'ぼうけんをきろくする'
      expect(page).to have_selector '#modal-new-doc'
    end
    context '目標編集モーダルのテスト' do
      before do
        click_on goal.category
      end

      it '目標のカテゴリーをクリックするとその目標の編集モーダルが表示される' do
        expect(page).to have_selector '#modal-goal' + goal.id.to_s + '-edit'
      end
      it '目標編集成功のテスト' do
        fill_in 'goal[category]', with: 'テスト'
        fill_in 'goal[goal_status]', with: 'テスト成功'
        click_on 'へんこう'
        expect(page).to have_content 'もくひょうをへんこうしました'
        expect(goal.reload.category).to eq 'テスト'
        expect(goal.reload.goal_status).to eq 'テスト成功'
      end
      it '目標編集失敗のテスト' do
        fill_in 'goal[category]', with: ''
        fill_in 'goal[goal_status]', with: ''
        click_on 'へんこう'
        expect(page).to have_selector '.error__message'
      end
      it '目標削除のテスト' do
        page.accept_confirm do
          click_on 'さくじょ'
        end
        expect(page).to have_content 'もくひょうをさくじょしました'
        expect(Goal.count).to eq 0
      end
    end
  end
end