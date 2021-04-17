class DocumentsController < ApplicationController
	def new
		@document = Document.new
		@user = current_user
	end

	def create
		@document = Document.new(document_params)
		@document.user_id = current_user.id
		if @document.save
		   flash[:level_up] = "LEVELUP!"
		   redirect_to user_path(current_user.id)
		else
			render "new"
		end
	end

	def show
		@document = Document.find(params[:id])
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
		   redirect_to user_path(current_user.id)
		else
		   render "edit"
		end
	end

	def destroy
		@document = Document.find(params[:id])
		@document.destroy
		flash[:notice] = "きろくをさくじょしました"
		redirect_to user_path(current_user.id)
	end

	private
	def document_params
		params.require(:document).permit(:title, :body, :document_image, :milestone, :add_level, :goal_id)
	end
end
