# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    callback_for(:google)
  end

  def facebook
    callback_for(:facebook)
  end

  def twitter
    callback_for(:twitter)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if !@user.is_active
      flash[:alert] = 'このアカウントは退会済みです。お手数ですが、別のアカウントをお使いください。'
      redirect_to new_user_session_path
    elsif @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "#{provider}アカウントでログインしました"
    else
      redirect_to new_user_registration_path
    end
  end

  def failure
    redirect_to root_path
  end
end
