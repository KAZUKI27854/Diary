require 'rails_helper'

describe '6.ユーザログイン後の目標関連のテスト', type: :feature, js: true do
  let!(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
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

    context '目標が4つ以上ある場合' do
      before do
        create_list(:goal, 3, user_id: user.id)
        visit my_page_path
        all('.my-page__menu--icon')[1].click
      end

      it '目標メニューにセレクトボックスが表示されている' do
        expect(page).to have_selector '.js-menu-goal-select'
      end

      it 'セレクトボックスの目標をクリックすると、更新順に数えて4番目の目標の編集モーダルが表示される' do
        within '.js-menu-goal-select' do
          select goal.category
        end
        expect(page).to have_selector '#modal-goal' + goal.id.to_s + '-edit'
      end
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