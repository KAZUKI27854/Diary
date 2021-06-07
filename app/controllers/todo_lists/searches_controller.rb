class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    found_todo_lists = @user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%").page(params[:page])

    if params[:word].blank?
      todo_lists = @user.todo_lists.classify.page(params[:page])
			render partial: "todo_lists/todo_list", collection: todo_lists
    else
      render partial: "todo_lists/todo_list", collection: found_todo_lists
    end
  end

  def index_by_category
    #lists_result_by_word = @user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%")
    #lists_result_by_cat =  @user.goals.find_by(category: params[:category]).todo_lists

    if params[:category].blank? && params[:word].blank? then

      todo_lists = @user.todo_lists.classify.page(params[:page])

    elsif params[:category].present? && params[:word].present? then
      lists_result_by_cat =  @user.goals.find_by(category: params[:category]).todo_lists

      todo_lists = lists_result_by_cat.where('body LIKE(?)', "%#{params[:word]}%").classify.page(params[:page])

    elsif params[:category].present? && params[:word].blank? then
      todo_lists = @user.goals.find_by(category: params[:category]).todo_lists
    else
      todo_lists = @user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%")
    end

    render partial: "todo_lists/todo_list", collection: todo_lists
  end

  private

    def set_current_user
      @user = current_user
    end
end
