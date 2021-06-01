class TodoLists::SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_lists = current_user.todo_lists.where('body LIKE(?)', "%#{params[:word]}%")

    #respond_to do |format|
      #format.html { redirect_to :root }
      #format.json { render json: @todo_lists }
    #end
    
  end
end
