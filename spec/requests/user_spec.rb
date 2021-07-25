require 'rails_helper'

RSpec.describe 'sコントローラーのアクセス制御テスト', type: :request do
  let!(:user) { create(:user) }
  
  describe 'showアクション' do
    before do
      get my_page_path
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end
  
  describe 'updateアクション' do
    context '未ログインの場合' do
      before do
        user_params = attributes_for(:user, name: "test")
        patch user_path(user.id), :params => { :user => user_params }
      end
      
      it '未ログインの場合302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it '未ログインの場合ログイン画面にリダイレクトされる' do
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context 'ログイン済みで他のユーザーデータを更新しようとした場合' do
      let!(:another_user) { create(:user) }

      before do
        login_as(user, :scope => :user)
        user_params = attributes_for(:user, name: "test")
        patch user_path(another_user.id), :params => { :user => user_params }
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'マイページにリダイレクトされる' do
        expect(response).to redirect_to my_page_path
      end
    end
  end
  
  describe 'withdrawアクション' do
    before do
      patch withdraw_user_path
    end
    
    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end
end