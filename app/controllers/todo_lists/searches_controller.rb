class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_lists = current_user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%").page(params[:page])

    if params[:word].blank?
      todo_lists = current_user.todo_lists.classify.page(params[:page])
			render partial: "todo_lists/todo_list", collection: todo_lists
    else
      render partial: "todo_lists/todo_list", collection: @todo_lists
    end

  end
end
