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

	def edit
		@goal = Goal.find(params[:id])
	end

	def update
		user = current_user
		first_goal_edit = user.goals.first
		first_goal_edit.update(goal_params)
		redirect_to user_path(current_user.id)
	end

	private
	  def goal_params
		params.require(:goal).permit(:category, :goal_status, :milestone, :deadline)
	  end
end
