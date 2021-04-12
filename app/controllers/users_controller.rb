class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @documents = Document.where(user_id: params[:id])
    @documents_index = @documents.page(params[:page]).reverse_order
    @user_level = @documents.sum(:add_level)
    @goal = Goal.new
    @goals = Goal.where(user_id: params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = "データをへんこうしました"
        format.html {redirect_to user_path(current_user.id)}
      else
        format.js { render :errors }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "データをすべてさくじょしました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end
end
