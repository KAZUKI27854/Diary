require 'rails_helper'

RSpec.describe 'Goalsコントローラーのアクセス制御テスト', type: :request do
  describe 'createアクション' do
    before do
      goal_params = attributes_for(:goal)
      post "/goals", :params => { :goal => goal_params }
    end
    
    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to "/users/sign_in"
    end
  end
    
  describe 'updateアクション' do
    let!(:goal) { create(:goal) }
    
    context '未ログインの場合' do
      before do
        goal_params = attributes_for(:goal, goal_status: "新規目標")
        patch "/goals/1", :params => { :goal => goal_params }
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'ログイン画面にリダイレクトされる' do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
    
    context 'ログイン済みで他のユーザーの目標を編集しようとした場合' do
      let!(:another_user_goal) { create(:goal) }
      let!(:user) { User.first }
      
      before do
        login_as(user, :scope => :user)
        goal_params = attributes_for(:goal, goal_status: "新規目標")
        patch "/goals/2", :params => { :goal => goal_params }
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
    let!(:goal) { create(:goal) }
    
    context '未ログインの場合' do
      before do
        delete "/goals/1"
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'ログイン画面にリダイレクトされる' do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
    
    context 'ログイン済みで他のユーザーの目標を削除しようとした場合' do
      let!(:another_user_goal) { create(:goal) }
      let!(:user) { User.first }
      
      before do
        delete "/goals/2"
      end
      
      it '302エラーが発生する' do
        expect(response).to have_http_status "302"
      end
      it 'マイページにリダイレクトされる' do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end