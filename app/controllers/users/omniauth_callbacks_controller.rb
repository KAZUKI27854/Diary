# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Googleアカウントでログインしました"
    else
      redirect_to new_user_registration_path
    end
  end

  def failure
    redirect_to root_path
  end
end
