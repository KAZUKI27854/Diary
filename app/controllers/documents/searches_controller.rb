class Documents::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def index
    if params[:category].blank? && params[:word].blank?
      documents = @user.documents
    elsif params[:category].present? && params[:word].present?

      doc_result_by_cat = @user.goals.find_by(category: params[:category]).documents
      documents = doc_result_by_cat.where('body LIKE(?)', "%#{params[:word]}%")

    elsif params[:category].present? && params[:word].blank?
      documents = @user.goals.find_by(category: params[:category]).documents
    else
      documents = @user.documents.where('body LIKE(?)', "%#{params[:word]}%")
    end

    sort_documents = documents.includes(:goal).page(params[:page]).per(20).reverse_order
    render partial: "users/card", locals: { documents: sort_documents }
  end

  private

  def set_current_user
    @user = current_user
  end
end
