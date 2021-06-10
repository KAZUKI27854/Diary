class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :ensure_normal_user, only: :withdraw

  def show
    @document = Document.new
    @documents = @user.documents.includes(:goal).page(params[:page]).per(6).reverse_order

    @user_documents = @user.documents
    @user_level = @user_documents.sum(:add_level)

    @todo_list = TodoList.new
    @todo_lists = @user.todo_lists.classify.page(params[:page])

    @goal = Goal.new
    @goals = @user.goals.order("updated_at DESC")

    gon.goals = @goals.count
    gon.documents = @documents.count
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = "データをへんこうしました"
        format.html { redirect_to my_page_path }
      else
        format.js { render "user_errors" }
      end
    end
  end

  def withdraw
    @user.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  private

  def set_current_user
    @user = current_user
  end

  def ensure_normal_user
    if @user.email == 'guest@example.com'
      flash[:alert] = "ゲストはさくじょできません"
      redirect_to my_page_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end
end