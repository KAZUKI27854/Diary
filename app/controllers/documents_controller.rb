class DocumentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_current_user

	include DocumentsHelper

	def index
		selected_goal = @user.goals.find_by(category: params[:category])
		@selected_documents = selected_goal.documents.page(params[:page]).reverse_order
		@documents = @user.documents.page(params[:page]).reverse_order

        if @selected_documents.exists?
		  render partial: "users/card", locals: { documents: @selected_documents }
		else
		  render partial: "users/card", locals: { documents: @documents }
		end
	end

	def create
		@document = Document.new(document_params)
		@document.user_id = current_user.id
		goal = Goal.find(@document.goal_id)

		respond_to do |format|
		  if @document.save
		  	if goal.level < 100 && (goal.level + @document.add_level) >= 100
		  	  flash[:clear] = "#{goal.category}のレベルが100になった!!"
		  	else
		  	  flash[:level_up] = "LEVELUP!"
		  	end
		  	when_doc_post_goal_auto_update(goal.id)
		    format.html { redirect_to my_page_path }
		  else
			format.js { render "document_errors" }
		  end
		end
	end

	def edit
		@document = Document.find(params[:id])
		if @document.user.id != current_user.id
			redirect_to root_path
		end
	end

	def update
		@document = Document.find(params[:id])
		if @document.update(document_params)
		   flash[:notice] = "きろくをへんこうしました"
		   redirect_to my_page_path
		else
		   render "edit"
		end
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
