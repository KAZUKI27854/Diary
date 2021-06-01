class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @document = Document.new
    @documents = current_user.documents.page(params[:page]).reverse_order
    @user_level = @documents.sum(:add_level)

    @goal = Goal.new
    @goals = @user.goals.order(updated_at: "DESC")

    @todo_list = TodoList.new
    @todo_lists = @user.todo_lists

    gon.goals = @goals.count
    gon.documents = @documents.count
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = "データをへんこうしました"
        format.html { redirect_to my_page_path }
      else
        format.js { render "user_errors" }
      end
    end
  end


  def destroy
    @user = current_user
    @user.destroy
    flash[:notice] = "データをすべてさくじょしました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end
end
