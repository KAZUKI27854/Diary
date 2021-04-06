class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    @skill1 = @user.skill1
    skill1_ary = Document.where(title: "#{@skill1}").pluck(:title)
    @skill1_level = skill1_ary.count("#{@skill1}")
    @skill2 = @user.skill2
    skill2_ary = Document.where(title: "#{@skill2}").pluck(:title)
    @skill2_level = skill2_ary.count("#{@skill2}")
    @skill3 = @user.skill3
    skill3_ary = Document.where(title: "#{@skill3}").pluck(:title)
    @skill3_level = skill3_ary.count("#{@skill3}")

    @documents = Document.where(user_id: params[:id]).page(params[:page]).reverse_order

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
