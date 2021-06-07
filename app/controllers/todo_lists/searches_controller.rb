class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    @todo_lists = @user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%").page(params[:page])

    if params[:word].blank?
      todo_lists = @user.todo_lists.classify.page(params[:page])
			render partial: "todo_lists/todo_list", collection: todo_lists
    else
      render partial: "todo_lists/todo_list", collection: @todo_lists
    end

  end

  private

    def set_current_user
      @user = current_user
    end
end
