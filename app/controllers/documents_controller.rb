class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :ensure_goal_deadline

  include DocumentsHelper
  include GoalsHelper

  def create
    @document = Document.new(document_params)
    @document.user_id = @user.id
    goal = Goal.find(@document.goal_id)
    respond_to do |format|
      if @document.save
        # はじめて目標レベル100を超えた場合、クリア時のフラッシュ演出実行
        if goal.level < 100 && (goal.level + @document.add_level) >= 100
          flash[:clear] = "#{goal.category}のレベルが100になった！！"
        else
          flash[:level_up] = "#{@user.name}のレベルが #{@document.add_level} 上がった！"
        end
        # 関連する目標データのdoc_number,stage_idを更新
        when_doc_create_goal_auto_update(goal.id)
        format.html { redirect_to my_page_path }
      else
        format.js { render "document_errors" }
      end
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    goal = @document.goal
    update_goal = Goal.find(params[:document][:goal_id])
    Document.transaction do
      if @document.update(document_params)
        # ドキュメント更新時に目標が変わっているかで条件分岐
        case update_goal.id
        # 目標が変わっていない場合、獲得レベルの差分だけ目標レベルに加える
        when goal.id
          origin_add_level = params[:document][:origin_add_level].to_i
          update_add_level = params[:document][:add_level].to_i
          goal.level += (update_add_level - origin_add_level)
          goal.update(level: goal.level)
        # 目標が変わっている場合、変更前の目標と変更後の目標のデータを更新
        else
          when_doc_create_goal_auto_update(update_goal.id)
          when_doc_change_goal_origin_goal_auto_update
        end
        if params[:document][:document_image].present?
          # S3への画像反映のタイムラグを考慮して3秒待機
          sleep(3)
        end
        flash[:notice] = "きろくをへんこうしました"
        redirect_to my_page_path
      else
        render "edit"
      end
      rescue => e
        logger.error e.backtrace.join("\n")
        flash[:alert] = "エラーが発生しました。管理者へお問い合わせください。"
        redirect_to my_page_path
    end
  end

  def destroy
    document = Document.find(params[:id])
    Document.transaction do
      # 関連する目標のデータを更新
      when_doc_destroy_goal_auto_update(document.id)
      document.destroy
      flash[:notice] = "きろくをさくじょしました"
      redirect_to my_page_path
      rescue => e
        logger.error e.backtrace.join("\n")
        flash[:alert] = "エラーが発生しました。管理者へお問い合わせください。"
        redirect_to my_page_path
    end
  end

  private

  def set_current_user
    @user = current_user
  end

  def ensure_goal_deadline
    if over_deadline_goal_count >= 1
      flash[:alert] = 'きげん切れの目標を修正してください'
      redirect_to my_page_path
    end
  end

  def document_params
    params.require(:document).permit(:body, :document_image, :milestone, :add_level, :goal_id)
  end
end
