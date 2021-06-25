class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    if params[:goal_id].blank? && params[:word].blank?
      todo_lists = @user.todo_lists
    elsif params[:goal_id].present? && params[:word].present?
      todo_lists = Goal.find(params[:goal_id]).todo_lists.where('body LIKE(?)', "%#{params[:word]}%")
    elsif params[:goal_id].present? && params[:word].blank?
      todo_lists = Goal.find(params[:goal_id]).todo_lists
    else
      todo_lists = @user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%")
    end
    sort_lists = todo_lists.classify
    render partial: "todo_lists/todo_list", collection: sort_lists
  end

  private

  def set_current_user
    @user = current_user
  end
end
