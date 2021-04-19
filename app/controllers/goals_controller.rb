class GoalsController < ApplicationController

	def new
		@goal = Goal.new
	end

	def create
		@goal = Goal.new(goal_params)
		@goal.user_id = current_user.id

		respond_to do |format|
		  if @goal.save
		    flash[:notice] = "もくひょうをついかしました"
		    format.html { redirect_to user_path(current_user.id) }
		  else
			format.js { render "goal_errors" }
		  end
		end
	end

	def show
		@goal = Goal.find(params[:id])
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
			flash[:notice] = "もくひょうをへんこうしました"
		    redirect_to user_path(current_user.id)
		else
		    render "edit"
		end
	end

	def destroy
		goal = Goal.find(params[:id])
		goal.destroy
		flash[:notice] = "もくひょうをさくじょしました"
		redirect_to user_path(current_user.id)
	end

	private
	  def goal_params
		params.require(:goal).permit(:category, :goal_status, :deadline)
	  end
end
