class Documents::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    if params[:category].blank? && params[:word].blank? then
      documents = @user.documents
    elsif params[:category].present? && params[:word].present? then

      doc_result_by_cat =  @user.goals.find_by(category: params[:category]).documents
      documents = doc_result_by_cat.where('body LIKE(?)', "%#{params[:word]}%")

    elsif params[:category].present? && params[:word].blank? then
      documents = @user.goals.find_by(category: params[:category]).documents
    else
      documents = @user.documents.where('body LIKE(?)', "%#{params[:word]}%")
    end

    sort_documents = documents.page(params[:page]).per(6).reverse_order
    render partial: "users/card", locals: { documents: sort_documents }
  end

  private

    def set_current_user
      @user = current_user
    end
end
