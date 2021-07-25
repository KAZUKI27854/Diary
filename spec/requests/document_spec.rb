require 'rails_helper'

RSpec.describe 'Documentsコントローラーのアクセス制御テスト', type: :request do
  let!(:goal) { create(:goal) }
  let!(:user) { User.first }

  describe 'createアクション' do
    before do
      document_params = attributes_for(:document, goal: goal)
      post "/documents", :params => { :document => document_params }
    end

    it '未ログインの場合302エラーが発生する' do
      expect(response).to have_http_status "302"
    end
    it '未ログインの場合ログイン画面にリダイレクトされる' do
      expect(response).to redirect_to "/users/sign_in"
    end
  end
end