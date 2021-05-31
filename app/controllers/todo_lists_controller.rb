class TodoListsController < ApplicationController
  def index
    @goals = current_user.goals

    @todo_list = TodoList.new
    @todo_lists = current_user.todo_lists
  end

  def create
    @todo_list = TodoList.new(todo_list_params)
    @todo_list.user_id = current_user.id

    if @todo_list.save
      render :create
    else
      render :todo_list_errors
    end

    @todo_lists = current_user.todo_lists
  end

  private
    def todo_list_params
      params.require(:todo_list).permit(:goal_id, :body, :deadline)
    end
end
