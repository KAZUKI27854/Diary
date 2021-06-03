class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_user_todo_lists, only: [:index]

  def index
    @goals = @user.goals
    @todo_list = TodoList.new
  end

  def create
    @todo_list = TodoList.new(todo_list_params)
    @todo_list.user_id = @user.id

    deadline = params[:todo_list][:deadline]
    if deadline.blank?
      @todo_list.priority = 1
    end

    if @todo_list.save
      @todo_lists = @user.todo_lists.classify.page(params[:page]).per(10)
      render :create
    else
      render :todo_list_errors
    end
  end

  def edit
    @todo_list = TodoList.find(params[:id])
    @goals = @user.goals
  end

  def update
    @todo_list = TodoList.find(params[:id])

    deadline = params[:todo_list][:deadline]
    unless deadline.blank?
      @todo_list.priority = 0
    end

    if @todo_list.update(todo_list_params)
      @todo_lists = @user.todo_lists.classify.page(params[:page]).per(10)
      render :update
    else
      render :todo_list_errors
    end
  end

  def check
    @todo_list = TodoList.find(params[:id])
    if @todo_list.is_finished == false then
      @todo_list.update_attributes(is_finished: true, priority: 2)
    elsif @todo_list.is_finished == true && @todo_list.deadline == nil then
      @todo_list.update_attributes(is_finished: false, priority: 1)
    else
      @todo_list.update_attributes(is_finished: false, priority: 0)
    end
    @todo_lists = @user.todo_lists.classify.page(params[:page]).per(10)
  end

  def destroy
    todo_list = TodoList.find(params[:id])
    todo_list.destroy
    @todo_lists = @user.todo_lists.classify.page(params[:page]).per(10)
  end

  private

    def set_current_user
      @user = current_user
    end

    def set_user_todo_lists
      @todo_lists = @user.todo_lists.classify.page(params[:page]).per(10)
    end

    def todo_list_params
      params.require(:todo_list).permit(:goal_id, :body, :deadline, :priority)
    end
end
