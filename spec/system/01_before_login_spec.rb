require 'rails_helper'

describe '1.ユーザログイン前のテスト' do
  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「ぼうけんのはじまりじゃ」と表示される' do
        expect(page).to have_content 'ぼうけんのはじまりじゃ'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'とうろくボタンが表示される' do
        expect(page).to have_button 'とうろく'
      end
    end
  end
end