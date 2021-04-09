class GoalsController < ApplicationController

	def new
		@goal = Goal.new
	end

	def create
		@goal = Goal.new(goal_params)
		@goal.user_id = current_user.id
		if @goal.save
		  redirect_to user_path(current_user.id)
		else
			render "new"
		end
	end

	def show
		@goal = Goal.find(params[:id])
	end

	def index
		@user = current_user
	end

	def edit
		@goal = Goal.find(params[:id])
		if @goal.user_id != current_user.id
			redirect_to root_path
		end
	end

	def update
		@goal = Goal.find(params[:id])
		if @goal.update(goal_params)
		  redirect_to user_path(current_user.id)
		else
		  render "edit"
		end
	end

	def destroy
		goal = Goal.find(params[:id])
		goal.destroy
		redirect_to user_path(current_user.id)
	end

	private
	  def goal_params
		params.require(:goal).permit(:category, :goal_status, :deadline)
	  end
end
