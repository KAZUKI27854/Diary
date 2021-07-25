require 'rails_helper'

RSpec.describe 'TodoListsコントローラーのアクセス制御テスト', type: :request do
  let!(:goal) { create(:goal) }
  let!(:user) { User.first }
  let!(:todo_list) { create(:todo_list, goal_id: goal.id) }

  describe 'indexアクション' do
    before do
      get todo_lists_path
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'createアクション' do
    before do
      todo_list_params = attributes_for(:todo_list, goal: goal)
      post "/todo_lists", :params => { :todo_list => todo_list_params }
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'updateアクション' do
    before do
      todo_list_params = attributes_for(:todo_list, goal: goal, body: "test")
      patch todo_list_path(todo_list.id), :params => { :todo_list => todo_list_params }
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end
  
  describe 'destoryアクション' do
    before do
      delete "/todo_lists/1"
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to new_user_session_path
    end
  end
end