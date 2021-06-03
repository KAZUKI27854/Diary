class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, :set_user_todo_lists

  def index
    @goals = @user.goals
    @todo_list = TodoList.new
  end

  def create
    @todo_list = TodoList.new(todo_list_params)
    @todo_list.user_id = @user.id

    if @todo_list.save
      render :create
    else
      render :todo_list_errors
    end
  end

  def edit
    @todo_list = @user.todo_lists.find(params[:id])
    @goals = @user.goals
  end

  def update
    @todo_list = @todo_lists.find(params[:id])
    if @todo_list.update(todo_list_params)
      render :update
    else
      render :todo_list_errors
    end
  end

  def check
    @todo_list = @todo_lists.find(params[:id])
    if @todo_list.is_finished == false
      @todo_list.update(is_finished: true)
    else
      @todo_list.update(is_finished: false)
    end
  end

  def destroy
    todo_list = @todo_lists.find(params[:id])
    todo_list.destroy
  end

  private

    def set_current_user
      @user = current_user
    end

    def set_user_todo_lists
      @todo_lists = @user.todo_lists
    end

    def todo_list_params
      params.require(:todo_list).permit(:goal_id, :body, :deadline)
    end
end
