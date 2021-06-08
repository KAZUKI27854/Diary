class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    if params[:category].blank? && params[:word].blank? then
      todo_lists = @user.todo_lists
    elsif params[:category].present? && params[:word].present? then

      lists_result_by_cat =  @user.goals.find_by(category: params[:category]).todo_lists
      todo_lists = lists_result_by_cat.where('body LIKE(?)', "%#{params[:word]}%")

    elsif params[:category].present? && params[:word].blank? then
      todo_lists = @user.goals.find_by(category: params[:category]).todo_lists
    else
      todo_lists = @user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%")
    end

    sort_lists = todo_lists.classify.page(params[:page])
    render partial: "todo_lists/todo_list", collection: sort_lists
  end

  private

    def set_current_user
      @user = current_user
    end
end
