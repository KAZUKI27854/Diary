module UsersHelper
	def first_goal
		@user.goals.first
	end

	def second_goal
		@user.goals.second
	end

	def third_goal
		@user.goals.third
	end
end
