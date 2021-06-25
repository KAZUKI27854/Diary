require 'rails_helper'

describe '7.ユーザログイン後のドキュメント関連のテスト', type: :feature, js: true do
  let!(:goal) { create(:goal, level: 80) }
  let!(:user) { User.first }

  before do
    login_as(user, :scope => :user)
    visit  my_page_path
  end

  context 'ドキュメント作成成功のテスト' do
    before do
      click_link 'きろくする'
      within '#document_goal_id' do
        select goal.category
      end
      attach_file 'document[document_image]', "#{Rails.root}/app/assets/images/character/brave.png"
      fill_in 'document[body]', with: 'テスト'
      fill_in 'document[milestone]', with: 'テスト成功'
    end

    it 'メニューの「きろくする」をクリックすると、ドキュメント作成モーダルが表示される' do
      expect(page).to have_selector "#modal-new-doc"
    end
    it 'ドキュメント作成成功のテスト（目標レベル100以下の場合）' do
      within '#document_add_level' do
        select 10
      end
      click_button 'きろくする'
      expect(page).to have_selector '.levelup__back'
      expect(Document.count).to eq 1
    end
    it '目標レベルが初めて100を越えた場合、投稿後のフラッシュ演出が変化している' do
      within '#document_add_level' do
        select 20
      end
      click_button 'きろくする'
      expect(page).to have_selector '.clear__back'
      expect(Document.count).to eq 1
    end
  end

  it 'ドキュメント作成失敗のテスト' do
    click_link 'きろくする'
    fill_in 'document[body]', with: ''
    fill_in 'document[milestone]', with: ''
    click_button 'きろくする'
    expect(page).to have_selector '.error__message'
    expect(Document.count).to eq 0
  end

  context 'ドキュメント編集成功のテスト' do
    let!(:goal) { create(:goal, level: 10) }
    let!(:goal_2) { create(:goal, user_id: user.id, level: 5) }
    let!(:document) { create(:document, user_id: user.id, goal_id: goal.id, add_level: 10) }

    before do
      visit '/documents/1/edit'
      attach_file 'document[document_image]', "#{Rails.root}/app/assets/images/character/brave.png"
      fill_in 'document[body]', with: 'テスト'
      fill_in 'document[milestone]', with: 'テスト成功'
      within '#document_add_level' do
        select 20
      end
    end

    it 'ドキュメントの目標以外の項目が変更できる' do
      click_button 'きろくしなおす'
      expect(current_path).to eq my_page_path
      expect(page).to have_content 'きろくをへんこうしました'
      expect([document.reload.document_image_id]).to be_present
      expect(document.reload.body).to eq 'テスト'
      expect(document.reload.milestone).to eq 'テスト成功'
      expect(document.reload.add_level).to eq 20
    end
    it 'ドキュメントの目標を変更すると、変更前と後の目標のレベルや投稿数も変更される' do
      within '#document_goal_id' do
        select goal_2.category
      end
      click_button 'きろくしなおす'
      expect(page).to have_content 'きろくをへんこうしました'
      # 変更前の目標データが変わっているか
      expect(goal.reload.level).to eq 0
      expect(goal.reload.doc_count).to eq 0
      # 変更後の目標データが変わっているか
      expect(goal_2.reload.level).to eq 25
      expect(goal_2.reload.doc_count).to eq 2
    end
  end

  context 'ドキュメント編集失敗のテスト' do
    let!(:document) { create(:document, body: 'テスト', user_id: user.id) }

    before do
      visit '/documents/1/edit'
      fill_in 'document[body]', with: ''
      fill_in 'document[milestone]', with: ''
      click_button 'きろくしなおす'
    end

    it '入力値が空のものがある場合、エラーメッセージが表示される' do
      expect(page).to have_selector '.error__message'
    end
    it 'ドキュメント編集に失敗している' do
      expect(document.reload.body).to eq 'テスト'
    end
  end

  context 'ドキュメント削除のテスト' do
    let!(:document) { create(:document, user_id: user.id, goal_id: goal.id, add_level: 80) }

    before do
      visit my_page_path
      page.accept_confirm do
        find('.doc-card__icon--delete').click
      end
    end

    it 'ドキュメントが削除され、フラッシュメッセージが表示されている' do
      expect(page).to have_content 'きろくをさくじょしました'
      expect(Document.count).to eq 0
    end
    it 'マイページにリダイレクトされている' do
      expect(current_path).to eq my_page_path
    end
    it '削除したドキュメントに関連する目標データが更新されている' do
      expect(page).to have_content 'きろくをさくじょしました'
      expect(goal.reload.level).to eq 0
      expect(goal.reload.doc_count).to eq 0
    end
  end

  describe 'ドキュメント一覧表示のテスト' do
    before do
      create_list(:document, 6, user_id: user.id, goal_id: goal.id)
      visit current_path
    end

    context '表示件数と順番のテスト' do
      before do
        # documentデータが合計7つできるよう追加で作成
        create(:document, user_id: user.id, goal_id: goal.id)
        visit current_path
      end

      it 'ドキュメントの表示件数が6件である' do
        expect(all('.doc-card').size).to eq(6)
      end
      it '更新順に表示されている： 最初に作成されたドキュメントを除く6件が表示されている' do
        documents = Document.where(id: 2..7)
        documents.each do |document|
          expect(page).to have_content document.body
        end
      end
    end

    context '画像のテスト' do
      # 6回目の投稿から順に表示されている
      it '投稿回数が5の倍数の時、ボスモンスターが表示される' do
        # 5回目の投稿
        card = find_all('.doc-card')[1]
        expect(card).to have_selector 'div[class=doc-card__monster--boss]'
      end
      it '投稿回数が5の倍数の時、モンスター2体は表示されない' do
        card = find_all('.doc-card')[1]
        expect(card).not_to have_selector 'div[class=doc-card__monster--right]'
        expect(card).not_to have_selector 'div[class=doc-card__monster--left]'
      end
      it '投稿回数が5の倍数でない時、モンスターが２体表示される' do
        card = find_all('.doc-card')[0]
        expect(card).to have_selector 'div[class=doc-card__monster--right]'
        expect(card).to have_selector 'div[class=doc-card__monster--left]'
      end
      it '投稿回数が5の倍数でない時、ボスモンスターは表示されない' do
        card = find_all('.doc-card')[0]
        expect(card).not_to have_selector 'div[class=doc-card__monster--boss]'
      end
    end
  end

  describe 'ドキュメント検索のテスト' do
    let!(:goal_2) { create(:goal, user_id: user.id) }
    # 目標1に関するドキュメント
    let!(:doc) { create(:document, :doc_1, user_id: user.id, goal_id: goal.id) }
    let!(:doc_2) { create(:document, :doc_2, user_id: user.id, goal_id: goal.id) }
    # 目標2に関するドキュメント
    let!(:doc_3) { create(:document, :doc_3, user_id: user.id, goal_id: goal_2.id) }
    let!(:doc_4) { create(:document, :doc_4, user_id: user.id, goal_id: goal_2.id) }

    before do
      def select_first_goal_category
        within '#goal_id' do
          select goal.category
        end
      end

      visit current_path
    end

    context 'セレクトボックス単体のテスト' do
      it 'セレクトボックスを「すべてのもくひょう」にして検索すると全てのドキュメントが表示される' do
        click_on 'けんさく'
        expect(page).to have_selector('.doc-card', count: 4)
      end
      it 'セレクトボックスを選択後に検索すると、選んだ目標のドキュメントのみ表示される' do
        select_first_goal_category
        click_on 'けんさく'
        expect(page).to have_content doc.body
        expect(page).to have_content doc_2.body
        expect(page).not_to have_content doc_3.body
        expect(page).not_to have_content doc_4.body
      end
    end

    context 'フォーム単体のテスト' do
      it '入力フォームが空の状態で検索すると全てのドキュメントが表示される' do
        click_on 'けんさく'
        expect(page).to have_selector('.doc-card', count: 4)
      end
      it '検索用フォームに文字を入力すると、本文にその文字が含まれるドキュメントのみ表示される' do
        fill_in 'word', with: '1つ目の'
        click_on 'けんさく'
        # 1つ目という文字列が含まれたドキュメント1だけ表示されているか
        expect(page).to have_content doc.body
        expect(page).to have_selector('.doc-card', count: 1)
      end
    end

    context 'セレクトボックスとフォーム併用時のテスト' do
      before do
        select_first_goal_category
        fill_in 'word', with: '1'
      end

      it '同時に検索ができる' do
        click_on 'けんさく'
        # 目標1かつ1という文字列が含まれたドキュメント1だけ表示されているか
        expect(page).to have_content doc.body
        expect(page).to have_selector('.doc-card', count: 1)
      end
      it 'セレクトボックスを「すべてのもくひょう」に戻すと、フォームの文字でのみ検索され、表示される' do
        within '#goal_id' do
          select 'すべてのもくひょう'
        end
        click_on 'けんさく'
        # 1という文字列が含まれたドキュメント1,4だけ表示されているか
        expect(page).to have_content doc.body
        expect(page).to have_content doc_4.body
        expect(page).not_to have_content doc_2.body
        expect(page).not_to have_content doc_3.body
      end
      it '入力フォームを空にすると、セレクトボックスの目標でのみ検索され、表示される' do
        fill_in 'word', with: ''
        click_on 'けんさく'
        # 目標1に関する投稿である、ドキュメント1,2だけ表示されているか
        expect(page).to have_content doc.body
        expect(page).to have_content doc_2.body
        expect(page).not_to have_content doc_3.body
        expect(page).not_to have_content doc_4.body
      end
    end
  end
end
