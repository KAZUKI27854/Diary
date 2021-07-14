class Documents::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    @document = Document.new
    @user_documents = @user.documents
    @user_level = @user_documents.sum(:add_level)

    @goal = Goal.new
    @goals = @user.goals.order("updated_at DESC")
    gon.goals = @goals.count

    if params[:goal_id].blank? && params[:word].blank?
      documents = @user.documents
    elsif params[:goal_id].present? && params[:word].present?
      documents = Goal.find(params[:goal_id]).documents.search(params[:word])
    elsif params[:goal_id].present? && params[:word].blank?
      documents = Goal.find(params[:goal_id]).documents
    else
      documents = @user.documents.search(params[:word])
    end
    @documents = documents.includes(:goal).page(params[:page]).per(6).reverse_order
  end

  private

  def set_current_user
    @user = current_user
  end
end
