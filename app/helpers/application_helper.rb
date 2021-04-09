module ApplicationHelper
	def user_goals
		goals = @user.goals
		goals.sort do |a, b|
			b[:updated_at] <=> a[:updated_at]
		end
	end

	def first_goal
		user_goals.first
	end

	def second_goal
		user_goals.second
	end

	def third_goal
		user_goals.third
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
