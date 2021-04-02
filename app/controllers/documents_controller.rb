class DocumentsController < ApplicationController
	def new
		@document = Document.new
	end

	def create
		@document = Document.new(document_params)
	end

	def show
	end

	def edit
	end

	def update
	end

	def destroy
	end

end
