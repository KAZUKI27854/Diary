class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_lists = current_user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%")

    respond_to do |format|
      format.html { redirect_to :root }
      format.json { render json: @todo_lists }
    end

    #if params[:word].blank?
      #todo_lists = @user.todo_lists
			#render partial: "todo_lists/todo_list", collection: todo_lists
    #else
      #render partial: "todo_lists/todo_list", collection: todo_lists
    #end

  end
end
