class TodoListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @goals = current_user.goals

    @todo_list = TodoList.new
    @todo_lists = current_user.todo_lists
  end

  def create
    @todo_list = TodoList.new(todo_list_params)
    @todo_list.user_id = current_user.id
    @todo_lists = current_user.todo_lists

    if @todo_list.save
      render :create
    else
      render :todo_list_errors
    end
  end

  def edit
    @todo_list = current_user.todo_lists.find(params[:id])
  end

  def update
    @todo_lists = current_user.todo_lists

    @todo_list = @todo_lists.find(params[:id])
    if @todo_list.update(todo_list_params)
      render :update
    else
      render :todo_list_errors
    end
  end

  def destroy
    @todo_lists = current_user.todo_lists

    todo_list = @todo_lists.find(params[:id])
    todo_list.destroy
  end

  private
    def todo_list_params
      params.require(:todo_list).permit(:goal_id, :body, :deadline)
    end
end
