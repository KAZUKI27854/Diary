module UsersHelper

    def category_level(goal_id)
      Document.where(goal_id: goal_id).sum(:add_level)
    end

    def clear_times
      goals = @user.goals

      goals.each do |goal|
      	category_level(goal.id)
      end
      category_level(goal.id).count {|level| level >= 100}
    end

	def category_name(id)
	  Goal.find_by(id: id).category
	end

	def timelimit(id, document)
	  ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
	end
end
