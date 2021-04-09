module ApplicationHelper
	def user_goals
		goals = @user.goals
		goals.sort do |a, b|
			b[:updated_at] <=> a[:updated_at]
		end
	end

end
