class DocumentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user

	include DocumentsHelper

	def create
	  @document = Document.new(document_params)
	  @document.user_id = @user.id
	  goal = Goal.find(@document.goal_id)

	  respond_to do |format|
	    if @document.save
	  	  if goal.level < 100 && (goal.level + @document.add_level) >= 100
	  	    flash[:clear] = "#{goal.category}のレベルが100になった!!"
	  	  else
	  	    flash[:level_up] = "LEVELUP!"
	  	  end
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

      #respond_to do |format|
	    if @document.update(document_params)
	      #ドキュメント更新時に目標が変わっているかで条件分岐
    	  case update_goal.id
    	  #目標が変わっていない場合、獲得レベルの差分だけ目標レベルに加える
    	  when goal.id
    	  	origin_add_level = params[:document][:origin_add_level].to_i
    	  	update_add_level = params[:document][:add_level].to_i
    	  	goal.level += (update_add_level - origin_add_level)
		    goal.update(level: goal.level)
		  #目標が変わっている場合、変更前の目標と変更後の目標のデータを更新
    	  else
    	  	when_doc_create_goal_auto_update(update_goal.id)
    	  	when_doc_change_goal_origin_goal_auto_update
          end
	      flash[:notice] = "きろくをへんこうしました"
		    #format.html { redirect_to my_page_path }
		    redirect_to my_page_path
	    else
	      #format.js { render "document_errors" }
	      render "edit"
	    end
	  #end
	end

	def destroy
	  document = Document.find(params[:id])
	  when_doc_destroy_goal_auto_update(document.id)
	  document.destroy
	  flash[:notice] = "きろくをさくじょしました"
	  redirect_to my_page_path
	end

	private

	def set_current_user
	  @user = current_user
	end

	def document_params
	  params.require(:document).permit(:body, :document_image, :milestone, :add_level, :goal_id)
	end
end
