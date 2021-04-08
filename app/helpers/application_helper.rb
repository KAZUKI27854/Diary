module ApplicationHelper
	def first_goal
		@user.goals.first
	end

	def second_goal
		@user.goals.second
	end

	def third_goal
		@user.goals.third
	end

	def first_goal_level
		documents = Document.where(goal_id: first_goal.id)
		documents.sum(:add_level)
	end

	def second_goal_level
		documents = Document.where(goal_id: second_goal.id)
		documents.sum(:add_level)
	end

	def third_goal_level
		documents = Document.where(goal_id: third_goal.id)
		documents.sum(:add_level)
	end
end
