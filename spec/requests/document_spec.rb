require 'rails_helper'

RSpec.describe 'Documentsコントローラーのアクセス制御テスト', type: :request do
  let!(:goal) { create(:goal) }
  let!(:user) { User.first }
  let!(:document) { create(:document, goal_id: goal.id) }

  describe 'createアクション' do
    before do
      document_params = attributes_for(:document, goal: goal)
      post documents_path, :params => { :document => document_params }
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'editアクション' do
    context '未ログインの場合' do
      before do
        get edit_document_path(document.id)
      end

      it '未ログインの場合302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it '未ログインの場合ログイン画面にリダイレクトされる' do
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context 'ログイン済みで他のユーザーの編集画面に遷移しようとした場合' do
      let!(:another_user_goal) { create(:goal) }
      let!(:another_user_document) { create(:document, goal_id: another_user_goal.id) }

      before do
        login_as(user, :scope => :user)
        get edit_document_path(another_user_document.id)
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'マイページにリダイレクトされる' do
        expect(response).to redirect_to my_page_path
      end
    end
  end
  
  describe 'updateアクション' do
    context '未ログインの場合' do
      before do
        document_params = attributes_for(:document, goal: goal, body: "test")
        patch document_path(document.id), :params => { :document => document_params }
      end

      it '未ログインの場合302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it '未ログインの場合ログイン画面にリダイレクトされる' do
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context 'ログイン済みで他のユーザーの編集画面に遷移しようとした場合' do
      let!(:another_user_goal) { create(:goal) }
      let!(:another_user_document) { create(:document, goal_id: another_user_goal.id) }

      before do
        login_as(user, :scope => :user)
        document_params = attributes_for(:document, goal: goal, body: "test")
        patch document_path(another_user_document.id), :params => { :document => document_params }
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'マイページにリダイレクトされる' do
        expect(response).to redirect_to my_page_path
      end
    end
  end
  
  describe 'destroyアクション' do
    context '未ログインの場合' do
      before do
        delete "/documents/1"
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'ログイン画面にリダイレクトされる' do
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context 'ログイン済みで他のユーザーの目標を削除しようとした場合' do
      let!(:another_user_goal) { create(:goal) }
      let!(:another_user_document) { create(:document, goal_id: another_user_goal.id) }

      before do
        login_as(user, :scope => :user)
        delete "/documents/2"
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'マイページにリダイレクトされる' do
        expect(response).to redirect_to my_page_path
      end
    end
  end
end