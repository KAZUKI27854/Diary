require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:goal) { create(:goal, user_id: user.id) }
  let!(:document) { build(:document, user_id: user.id, goal_id: goal.id) }


  describe 'editアクションのテスト' do
    context '未ログインユーザーの場合'
    it 'レスポンスが302（失敗）である' do
      get :edit, params: {user_id: user.id}
      expect(response).to have_http_status '302'
    end

    it 'editアクションを行うとtopへリダイレクトする' do
      get :edit, params: {user_id: user.id}
      expect(response).to redirect_to root_path
    end
  end

end