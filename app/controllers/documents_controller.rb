class DocumentsController < ApplicationController
	def new
		@document = Document.new
		@user = current_user
	end

	def create
		document = Document.new(document_params)
		document.user_id = current_user.id
		document.save
		redirect_to user_path(current_user.id)
	end

	def show
		@document = Document.find(params[:id])
	end

	def edit
		@document = Document.find(params[:id])
	end

	def update
		document = Document.find(params[:id])
		document.update(document_params)
		redirect_to user_path(current_user.id)
	end

	def destroy
		document = Document.find(params[:id])
		document.destroy(document_params)
		redirect_to user_path(current_user.id)
	end

	private
	def document_params
		params.require(:document).permit(:title, :body, :diary_image)
	end
end
