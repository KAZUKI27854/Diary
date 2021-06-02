class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    @goals = @user.goals

    @todo_list = TodoList.new
    @todo_lists = @user.todo_lists
  end

  def create
    @todo_list = TodoList.new(todo_list_params)
    @todo_list.user_id = @user.id
    @todo_lists = @user.todo_lists

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
    @todo_lists = @user.todo_lists

    @todo_list = @todo_lists.find(params[:id])
    if @todo_list.update(todo_list_params)
      render :update
    else
      render :todo_list_errors
    end
  end

  def destroy
    @todo_lists = @user.todo_lists

    todo_list = @todo_lists.find(params[:id])
    todo_list.destroy
  end

  private

    def set_current_user
      @user = current_user
    end

    def todo_list_params
      params.require(:todo_list).permit(:goal_id, :body, :deadline)
    end
end
