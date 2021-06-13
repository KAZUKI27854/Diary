require 'rails_helper'

describe '5.ユーザログイン後のマイページのテスト', type: :feature do
  let!(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
  end

  describe '目標データ作成前のテスト' do
    it 'メニューの目標アイコンにバウンドアニメーションの為のクラスが追加されている', js: true do
      goal_icon = find '.my-page__menu--icon--goal'
      expect(goal_icon['class']).to include 'js-bound'
    end

    it 'ドキュメント作成アイコンがクリックできないようになっている', js: true do
      # find('.js-save-link').click
      #expect(find('#modal-new-doc', visible: false)).to_not be_visible
      #expect(page).to have_selector '.new-doc'
      #expect(page).to have_no_content 'ぼうけんをきろくできるぞ'
      # binding.irb
      expect(page).not_to have_selector('.modal')
    end
  end
end