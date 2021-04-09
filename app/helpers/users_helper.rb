module UsersHelper
  
  
  
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

	def category_name(id)
	  Goal.find_by(id: id).category
	end

	def timelimit(id, document)
	  ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
	end
end
