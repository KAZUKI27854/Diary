class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @documents = Document.where(user_id: params[:id])
    @documents_index = @documents.page(params[:page]).reverse_order
    @user_level = @documents.sum(:add_level)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(current_user.id)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :skill1, :skill2, :skill3)
  end
end
